module ActiveHstore
  module ClassMethods
    def hstore_attr(*attrs)
      attrs.each do |key|
        key = key.to_s
        store_accessor :properties, key

        scope "has_#{key}", lambda { |value| where("properties -> ? = ?", key, value) }
      end
    end

    def hstore_indexed_attr(*attrs)
      attrs.each do |key|
        key = key.to_s
        store_accessor :indexed_properties, key

        scope "has_#{key}", lambda { |value| where("indexed_properties -> ? = ?", key, value) }
      end
    end
  end

  def self.included(base)
    base.extend(ClassMethods)
  end
end
