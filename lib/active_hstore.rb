module ActiveHstore
  module ClassMethods
    def hstore_attr(*attrs)
      attrs.each do |key|
        key = key.to_s
        attr_accessible key

        scope "has_#{key}", lambda { |value| where("properties @> hstore(?, ?)", key, value) }

        define_method(key) do
          properties[key] if self.properties.present?
        end

        define_method("#{key}=") do |value|
          self.properties = (properties || {}).merge(key => value)
        end
      end
    end

    def hstore_indexed_attr(*attrs)
      attrs.each do |key|
        key = key.to_s
        attr_accessible key

        scope "has_#{key}", lambda { |value| where("indexed_properties @> hstore(?, ?)", key, value) }

        define_method(key) do
          indexed_properties[key] if self.indexed_properties.present?
        end

        define_method("#{key}=") do |value|
          self.indexed_properties = (indexed_properties || {}).merge(key => value)
        end
      end
    end
  end

  def self.included(base)
    base.extend(ClassMethods)
  end
end
