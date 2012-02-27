class FindCodemarks
  def initialize(options = {})
    options.each do |key, val|
      self.instance_variable_set("@#{key.to_s}", val.to_param)
    end
  end

  def codemarks
    codemarks = Arel::Table.new(:codemark_records)
    subquery = codemarks.project(:id) \
          .group(codemarks[:link_record_id]) \
    subquery = subquery.where(codemarks[:user_id].eq(@user)) if @user

    subquery2 = codemarks.project('id, count(id) as save_count') \
          .group(codemarks[:link_record_id]) \
    subquery2 = subquery.where(codemarks[:user_id].eq(@user)) if @user

    query = CodemarkRecord.scoped
    query = query.select('*')
    query = query.joins("INNER JOIN (#{subquery2.to_sql}) cnt ON codemark_records.id = cnt.id")

    query = order(query)
    query = page_query(query)
    query = query.includes(:link_record)
    query = query.includes(:user)

    query = query.where(:id => subquery)
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
