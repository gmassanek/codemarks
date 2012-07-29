require 'fast_helper'

describe Resource do
  xit 'knows what saveObject to use' do
    resource = Resource.new(type: 'some_resource_type')
    resource.attributes
    resource.resource_type_class.should == 'some_resource_type'.constantize
  end

  describe '#initialize' do
    it 'picks off the type' do
      params = {
        type: 'text',
        saver_id: 5,
        attribute_1: 'I am some data',
        attribute_2: 'I am some data',
        attribute_3: 'I am some data'
      }
      resource = Resource.new(params)
      resource.attributes.should == {
        saver_id: 5,
        attribute_1: 'I am some data',
        attribute_2: 'I am some data',
        attribute_3: 'I am some data'
      }
    end
  end

end
