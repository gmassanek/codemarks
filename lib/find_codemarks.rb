class FindCodemarks
  PAGE_SIZE = 19

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
    subq = Codemark.scoped.select("id, ROW_NUMBER() OVER(#{partition_string}) AS rk")
    subq = subq.where(['user_id = ?', @user_id]) if @user_id
    subq = subq.where(['private = ? OR (private = ? AND codemarks.user_id = ?)', false, true, current_user_id])
    subq = if @group_ids
      subq.where('codemarks.group_id IN (?)', @group_ids)
    else
      subq.where('codemarks.group_id IS NULL OR codemarks.group_id IN (?)', Array(User.find_by_id(current_user_id).try(:group_ids)))
    end

    query = Codemark.scoped
    query = query.select('codemarks.id, codemarks.user_id, codemarks.resource_id, codemarks.created_at, codemarks.updated_at, codemarks.description, codemarks.title, codemarks.group_id, codemarks.private, counts.save_count, counts.visit_count')
    query = query.joins("RIGHT JOIN (#{subq.to_sql}) summary ON codemarks.id = summary.id")
    query = query.joins("LEFT JOIN (#{counts_query}) counts on codemarks.id = counts.id")

    query = query.where("summary.rk = 1")

    query = full_text_searchify(query) if @search_term

    if @topic_ids.present?
      query = join_topics(query, @topic_ids)
      query = query.where(["cm_topics_#{@topic_join_count}.count = ?", @topic_ids.count])
    end

    query = query.includes(:resource => {:author => :authentications})
    query = query.includes(:topics)
    query = query.includes(:user => :authentications)

    query = order(query)
    query = page_query(query)
    query
  end

  def join_topics(query, topic_ids)
    @topic_join_count ||= 0
    @topic_join_count += 1
    query.joins("LEFT JOIN (#{CodemarkTopic.group('codemark_id').select('codemark_id, count(*)').where(:topic_id => topic_ids).to_sql}) cm_topics_#{@topic_join_count} on codemarks.id = cm_topics_#{@topic_join_count}.codemark_id")
  end

  def find_topic_ids_from_search_query
    return [] unless @search_term
    Topic.where("topics.search @@ #{search_term_sql}").pluck(:id)
  end

  private
  def partition_string
    query = "PARTITION BY codemarks.resource_id ORDER BY "
    query = query + "codemarks.user_id=#{current_user_id} DESC, " if current_user_id
    query = query + "codemarks.created_at DESC"
    query
  end

  def counts_query
    <<-SQL
      (SELECT codemarks.id, coalesce(clicks_count, 0) as visit_count, coalesce(codemarks_count, 0) as save_count
      FROM codemarks
      LEFT JOIN resources ON codemarks.resource_id = resources.id)
    SQL
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
      "count" => 'counts.save_count DESC NULLS LAST',
      "visits" => 'counts.visit_count DESC NULLS LAST',
      "popularity" => '(visit_count + save_count) DESC NULLS LAST',
      "buzzing" => '600000 * log(visit_count + save_count) + (EXTRACT(EPOCH FROM codemarks.created_at) - 1324234724.26583) DESC'
    }
  end

  def full_text_searchify(query)
    query = query.joins("LEFT JOIN resources ON codemarks.resource_id = resources.id")

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
    topics = Topic.find_all_by_id(@topic_ids).map(&:slug) if @topic_ids.present?
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
