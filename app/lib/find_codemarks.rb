class FindCodemarks
  PAGE_SIZE = 20

  def initialize(options = {})
    options.each do |key, val|
      self.instance_variable_set("@#{key.to_s}", val.to_param)
    end

    @user_id = options[:user].id if options[:user]
    @current_user_id = options[:current_user].id if options[:current_user]
    @topic_ids = options[:topic_ids]
  end

  def codemarks
    subq = CodemarkRecord.scoped.select("id, ROW_NUMBER() OVER(#{partition_string}) AS rk")
    subq = subq.where(['user_id = ?', @user_id]) if @user_id
    subq = filter_codemarks_project_out(subq)

    query = CodemarkRecord.scoped
    query = query.select('"codemark_records".*, save_count, visit_count')
    query = query.joins("RIGHT JOIN (#{subq.to_sql}) summary ON codemark_records.id = summary.id")
    query = query.joins("LEFT JOIN (#{count_query.to_sql}) counts on codemark_records.resource_id = counts.resource_id")
    query = query.joins("LEFT JOIN (#{visits_query.to_sql}) visits on codemark_records.resource_id = visits.resource_id")

    query = query.where("summary.rk = 1")
    query = query.where(['private = ? OR (private = ? AND codemark_records.user_id = ?)', false, true, @current_user_id])

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
    query.joins("LEFT JOIN (#{CodemarkTopic.group('codemark_record_id').select('codemark_record_id, count(*)').where(:topic_id => topic_ids).to_sql}) cm_topics_#{@topic_join_count} on codemark_records.id = cm_topics_#{@topic_join_count}.codemark_record_id")
  end

  def find_topic_ids_from_search_query
    return [] unless @search_term
    Topic.where("topics.search @@ #{search_term_sql}").pluck(:id)
  end

  private
  def partition_string
    'PARTITION BY "codemark_records".resource_id ORDER BY "codemark_records".created_at DESC'
  end

  def filter_codemarks_project_out(query)
    allowed_users = User.find(:all, :conditions => {:nickname => ['gmassanek', 'GravelGallery']})
    unless allowed_users.map(&:id).include?(@current_user_id)
      topic = Topic.find_by_title('codemarks')
      if topic && topic.codemark_records.present?
        query = query.where(['"codemark_records".id not in (?)', topic.codemark_records.map(&:id) ])
      end
    end
    query
  end

  def count_query
    count_query = CodemarkRecord.scoped.select('"codemark_records".resource_id, count(*) as save_count')
    count_query = count_query.group('codemark_records.resource_id')
    count_query
  end

  def visits_query
    visits_query = CodemarkRecord.scoped.select('"link_records".id as resource_id, COALESCE(count(clicks.*), 0) as visit_count')
    visits_query = visits_query.joins('LEFT JOIN link_records on codemark_records.resource_id = link_records.id')
    visits_query = visits_query.joins('LEFT JOIN clicks on link_records.id = clicks.link_record_id')
    visits_query = visits_query.group('link_records.id')
    visits_query
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
    return order_texts['search_relavance'] if @search_term
    order_by_text = order_texts[@by.to_s]
    order_by_text ||= order_texts["default"]
  end

  def order_texts
    {
      "default" => '"codemark_records".created_at DESC',
      "count" => 'save_count DESC',
      "visits" => 'visit_count DESC',
      'search_relavance' => "ts_rank_cd(codemark_records.search, #{search_term_sql}) DESC"
    }
  end

  def full_text_searchify(query)
    if find_topic_ids_from_search_query.present?
      query = join_topics(query, find_topic_ids_from_search_query)
      query = query.where("codemark_records.search @@ #{search_term_sql} OR cm_topics_#{@topic_join_count}.count > 0")
    else
      query = query.where("codemark_records.search @@ #{search_term_sql}")
    end
  end

  def search_term_sql
    @search_term_sql ||= ActiveRecord::Base.send(:sanitize_sql_array, ["plainto_tsquery('english', ?)", @search_term])
  end
end
