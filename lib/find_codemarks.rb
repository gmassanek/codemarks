class FindCodemarks
  PAGE_SIZE = 24

  def initialize(options = {})
    options.each do |key, val|
      self.instance_variable_set("@#{key.to_s}", val.to_param)
    end

    @user_id = options[:user].id if options[:user]
    @current_user = options[:current_user] if options[:current_user]
    @topic_ids = options[:topic_ids]
    if options[:group_ids]
      @group_ids = options[:group_ids].map(&:to_i) & (@current_user.try(:group_ids) || [])
    end

    record_lookup
  end

  def codemarks
    query = Codemark.scoped
    query = query.select('codemarks.id, codemarks.user_id, codemarks.resource_id, codemarks.created_at, codemarks.updated_at, codemarks.description, codemarks.title, codemarks.group_id, codemarks.private, resources.codemarks_count AS save_count, resources.clicks_count AS visit_count')
    query = query.joins("RIGHT JOIN (#{filter_query.to_sql}) summary ON codemarks.id = summary.id")
    query = query.joins(:resource)

    query = query.where("summary.rk = 1")
    query = full_text_searchify(query) if @search_term

    query = query.includes(:resource => {:author => :authentications})
    query = query.includes(:topics)
    query = query.includes(:user => :authentications)

    query = order(query)
    query = page_query(query)
    query
  end

  def find_topic_ids_from_search_query
    return [] unless @search_term
    Topic.for_user(@current_user).where("topics.search @@ #{search_term_sql}").pluck(:id)
  end

  private

  def filter_query
    query = Codemark.scoped.select("id, ROW_NUMBER() OVER(#{partition_string}) AS rk")
    query = query.where(:user_id => @user_id) if @user_id
    query = query.where(['private = ? OR (private = ? AND codemarks.user_id = ?)', false, true, current_user_id])
    if @group_ids
      query = query.where(:group_id => @group_ids)
    else
      query = query.where('codemarks.group_id IS NULL OR codemarks.group_id IN (?)', Array(User.find_by_id(current_user_id).try(:group_ids)))
    end
    if @topic_ids.present?
      query = join_topics(query, @topic_ids)
      query = query.where(["cm_topics_#{@topic_join_count}.count = ?", @topic_ids.count])
    end
    query
  end

  def join_topics(query, topic_ids)
    @topic_join_count ||= 0
    @topic_join_count += 1
    query.joins("LEFT JOIN (#{CodemarkTopic.group('codemark_id').select('codemark_id, count(*)').where(:topic_id => topic_ids).to_sql}) cm_topics_#{@topic_join_count} on codemarks.id = cm_topics_#{@topic_join_count}.codemark_id")
  end

  def partition_string
    query = "PARTITION BY codemarks.resource_id ORDER BY "
    query = query + "codemarks.user_id=#{current_user_id} DESC, " if current_user_id
    query = query + "codemarks.created_at DESC"
    query
  end

  def page_query(scope)
    scope = scope.page(page)
    scope = scope.per(per_page)
    scope
  end

  def page
    @page ||= 1
  end

  def per_page
    @per_page ||= PAGE_SIZE
  end

  def order(scope)
    scope = scope.order(order_by_text)
  end

  def order_by_text
    order_by_text = order_texts[@by.to_s]
    order_by_text ||= order_texts["default"]
  end

  def order_texts
    {
      "default" => '"codemarks".created_at DESC',
      "count" => 'codemarks_count DESC NULLS LAST',
      "visits" => 'clicks_count DESC NULLS LAST',
      "popularity" => '(log(2, clicks_count + 1) + codemarks_count) DESC NULLS LAST',
      "buzzing" => '650000 * log(log(2, clicks_count + 1) + codemarks_count) + (EXTRACT(EPOCH FROM codemarks.created_at) - 1324234724.26583) DESC'
    }
  end

  def full_text_searchify(query)
    if find_topic_ids_from_search_query.present?
      query = join_topics(query, find_topic_ids_from_search_query)
      query = query.where("codemarks.search @@ #{search_term_sql} OR cm_topics_#{@topic_join_count}.count > 0 OR resources.search @@ #{search_term_sql}")
    else
      query = query.where("codemarks.search @@ #{search_term_sql} OR resources.search @@ #{search_term_sql}")
    end
  end

  def search_term_sql
    @search_term_sql ||= ActiveRecord::Base.send(:sanitize_sql_array, ["plainto_tsquery('english', ?)", @search_term])
  end

  def search_params
    topics = Topic.for_user(@current_user).find_all_by_id(@topic_ids).map(&:slug) if @topic_ids.present?
    groups = Group.find_all_by_id(@group_ids)

    params = { }
    params[:page] = @page if @page
    params[:search_term] = @search_term if @search_term
    params[:topic_ids] = topics if topics.present?
    params[:groups] = groups.map(&:name) if groups.present?
    params[:user_filter] = User.find_by_id(@user_id).try(:slug) if @user_id
    params[:sort_by] = @by
    params
  end

  def record_lookup
    user_id = @current_user.try(:nickname) || 'logged-out'
    Global.track(:user_id => user_id, :event => 'codemark_lookup', :properties => search_params)
  end

  def current_user_id
    @current_user.try(:id)
  end
end
