class FindCodemarks
  def initialize(options = {})
    options.each do |key, val|
      self.instance_variable_set("@#{key.to_s}", val.to_param)
    end
  end

  def codemarks
    subq = CodemarkRecord.scoped.select("id, ROW_NUMBER() OVER(#{partition_string}) AS rk")
    subq = subq.where(['user_id = ?', @user]) if @user

    query = CodemarkRecord.scoped
    query = query.select('*')
    query = query.joins("RIGHT JOIN (#{subq.to_sql}) summary ON codemark_records.id = summary.id")
    query = query.where("summary.rk = 1")

    query = query.joins("LEFT JOIN (#{count_query.to_sql}) counts on codemark_records.link_record_id = counts.link_record_id")

    query = query.includes(:link_record)
    query = query.includes(:topics)
    query = query.includes(:user => :authentications)

    query = order(query)
    query = page_query(query)
    query
  end

  private
  def partition_string
    'PARTITION BY "codemark_records".link_record_id ORDER BY "codemark_records".created_at DESC'
  end

  def count_query
    count_query = CodemarkRecord.scoped.select("link_record_id, count(*) as save_count")
    count_query = count_query.group(:link_record_id)
    count_query = count_query.where(['user_id = ?', @user]) if @user
    count_query
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
    @per_page ||= 10
  end

  def order(scope)
    scope = scope.order(order_by_text)
  end

  def order_by_text
    order_by_text = order_texts[@by.to_s]
    order_by_text ||= 'created_at DESC'
  end

  def order_texts
    {
      "count" => 'save_count DESC'
    }
  end
end
