class Resource
  attr_accessor :type, :saver_id

  def initialize(params)
    @saver_id = params[:saver_id]
  end
end
