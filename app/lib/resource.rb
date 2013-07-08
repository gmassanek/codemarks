class Resource
  def self.create(type, attributes)
    type.constantize.create!(attributes)
  rescue NameError
    return nil
  end
end
