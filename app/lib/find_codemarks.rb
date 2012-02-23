class FindCodemarks
  def initialize(options = {})
    options.each do |key, val|
      self.instance_variable_set("@#{key.to_s}", val.to_param)
    end
  end

  def codemarks
    query = CodemarkRecord.scoped

    query = query.where(:user_id => @user) if @user
    query = query.group('codemark_records.link_record_id')
    query = query.select('cms.id, cms.link_record_id, cms.user_id, cms.created_at, cms.updated_at, count(*) as save_count')
    query = query.joins('INNER JOIN codemark_records cms on codemark_records.id = cms.id')

    query = order(query)
    query = page(query)
    query = query.includes(:link_record)
    query = query.includes(:user)
    query
  end

  private
  def page(scope)
    @page ||= 1
    @per_page ||= 10
    scope = scope.page(@page) if @page
    scope = scope.per(@per_page) if @per_page
    scope
  end

  def order(scope)
    @sort_by ||= "created_at"
    if @sort_by == 'save_count'
      sort_text = @sort_by + ' DESC'
    else
      sort_text = 'cms.' + @sort_by + ' DESC'
    end
    scope = scope.order(sort_text)
  end
end
