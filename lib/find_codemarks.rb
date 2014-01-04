class FindCodemarks
  PAGE_SIZE = 19

  def initialize(options = {})
    options.each do |key, val|
      self.instance_variable_set("@#{key.to_s}", val.to_param)
    end

    @user_id = options[:user].id if options[:user]
    @current_user_id = options[:current_user].id if options[:current_user]
    @topic_ids = options[:topic_ids]
    @group_ids = options[:group_ids] || User.find_by_id(@current_user_id).try(:group_ids)
    @group_ids = [Group::DEFAULT.id] unless @group_ids.present?
    @group_ids

    record_lookup
  end

  def codemarks
    subq = Codemark.scoped.select("id, ROW_NUMBER() OVER(#{partition_string}) AS rk")
    subq = subq.where(['user_id = ?', @user_id]) if @user_id
    subq = subq.where(['private = ? OR (private = ? AND codemarks.user_id = ?)', false, true, @current_user_id])
    subq = subq.where(:group_id => @group_ids)
    subq = filter_codemarks_project_out(subq)

    query = Codemark.scoped
    query = query.select('"codemarks".*, save_count, visit_count')
    query = query.joins("RIGHT JOIN (#{subq.to_sql}) summary ON codemarks.id = summary.id")
    query = query.joins("LEFT JOIN (#{count_query.to_sql}) counts ON codemarks.resource_id = counts.resource_id AND codemarks.resource_type = counts.resource_type")
    query = query.joins("LEFT JOIN (#{visits_query}) visits on codemarks.id = visits.id")

    query = query.where("summary.rk = 1")
    query = query.where(['private = ? OR (private = ? AND codemarks.user_id = ?)', false, true, @current_user_id])

    query = full_text_searchify(query) if @search_term

    if @topic_ids.present?
      query = join_topics(query, @topic_ids)
      query = query.where(["cm_topics_#{@topic_join_count}.count = ?", @topic_ids.count])
    end

    query = query.includes(:resource => {:author => :authentications})
    query = query.includes(:topics)
    query = query.includes(:user => :authentications)
    #query = query.includes(:comments)

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
    query = "PARTITION BY codemarks.resource_id, codemarks.resource_type ORDER BY "
    query = query + "codemarks.user_id=#{@current_user_id} DESC, " if @current_user_id
    query = query + "codemarks.created_at DESC"
    query
  end

  def filter_codemarks_project_out(query)
    allowed_users = User.find(:all, :conditions => {:nickname => ['gmassanek', 'GravelGallery']})
    unless allowed_users.map(&:id).include?(@current_user_id)
      topic = Topic.find_by_title('codemarks')
      if topic && topic.codemarks.present?
        query = query.where(['"codemarks".id not in (?)', topic.codemarks.map(&:id) ])
      end
    end
    query
  end

  def count_query
    count_query = Codemark.select('codemarks.resource_id, codemarks.resource_type, count(*) as save_count')
    count_query = count_query.group('codemarks.resource_id, codemarks.resource_type')
    count_query
  end

  def visits_query
    <<-SQL
      (SELECT codemarks.id, clicks_count as visit_count
      FROM codemarks
      LEFT JOIN links ON codemarks.resource_id = links.id
      WHERE codemarks.resource_type = 'Link'

      UNION

      SELECT codemarks.id, clicks_count as visit_count
      FROM codemarks
      LEFT JOIN texts ON codemarks.resource_id = texts.id
      WHERE codemarks.resource_type = 'Text')
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
      "count" => 'save_count DESC',
      "visits" => 'visit_count DESC',
    }
  end

  def full_text_searchify(query)
    query = query.joins("LEFT JOIN (#{resource_search_query}) resource_search ON codemarks.resource_id = resource_search.id AND codemarks.resource_type = resource_search.type")

    if find_topic_ids_from_search_query.present?
      query = join_topics(query, find_topic_ids_from_search_query)
      query = query.where("codemarks.search @@ #{search_term_sql} OR cm_topics_#{@topic_join_count}.count > 0 OR resource_search.search @@ #{search_term_sql}")
    else
      query = query.where("codemarks.search @@ #{search_term_sql} OR resource_search.search @@ #{search_term_sql}")
    end
  end

  def resource_search_query
    <<-SQL
      SELECT id, 'Link' AS type, search FROM links
      UNION
      SELECT id, 'Text' AS type, search FROM texts
    SQL
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
    params[:topic_ids] = topics if topics
    params[:groups] = groups.map(&:name) if groups
    params[:user_filter] = User.find_by_id(@user_id).try(:slug) if @user_id
    params
  end

  def record_lookup
    user_id = User.find_by_id(@current_user_id).try(:nickname) || 'logged-out'
    Global.track(:user_id => user_id, :event => 'codemark_lookup', :properties => search_params)
  end
end
