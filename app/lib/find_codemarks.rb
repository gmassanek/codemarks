class FindCodemarks
  def initialize(options = {})
    options.each do |key, val|
      self.instance_variable_set("@#{key.to_s}", val.to_param)
    end
  end

  def codemarks
    partition_str = 'PARTITION BY "codemark_records".link_record_id ORDER BY "codemark_records".created_at DESC'
    subq = CodemarkRecord.scoped.select("id, ROW_NUMBER() OVER(#{partition_str}) AS rk")
    subq = subq.where(['user_id = ?', @user]) if @user

    query = CodemarkRecord.scoped
    query = query.select('*')
    query = query.joins("RIGHT JOIN (#{subq.to_sql}) summary ON codemark_records.id = summary.id")
    query = query.where("summary.rk = 1")

    count_query = CodemarkRecord.scoped.select("link_record_id, count(*) as save_count")
    count_query = count_query.group(:link_record_id)
    count_query = count_query.where(['user_id = ?', @user]) if @user

    query = query.joins("LEFT JOIN (#{count_query.to_sql}) counts on codemark_records.link_record_id = counts.link_record_id")

    query = query.includes(:link_record)
    query = query.includes(:user)

    query = order(query)
    query = page_query(query)
    query
  end

  private
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
    @order_by ||= "created_at"
    if @order_by == 'save_count'
      return @order_by + ' DESC'
    else
      return @order_by + ' DESC'
    end
  end
end
