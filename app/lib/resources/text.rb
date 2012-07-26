class Resource::Text < Resource
  attr_accessor :text

  def initialize(params = {})
    @type = 'text'
    @text = params[:text]
    super
  end

end
