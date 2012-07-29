class Resource::Text < Resource
  attr_accessor :text

  def initialize(params = {})
    @type = 'text'
    @text = params[:text]
    super
  end

  def self.create!(attrs)

    resource_type_class.create!(attrs)
  end
end
