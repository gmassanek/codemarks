class Resource
  attr_accessor :type, :saver_id, :attributes

  def initialize(params)
    @saver_id = params[:saver_id]
    @attributes = params.except(:type)
  end

  def resource_type_class
    TextRecord if @type = 'text'
  end
end
