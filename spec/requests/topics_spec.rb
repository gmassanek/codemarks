require 'spec_helper'

describe TopicsController do
  describe '#index' do
    it 'serves all existing topics in JSON' do
      Fabricate(:topic)
      Fabricate(:topic)
      get topics_path
      response.should be_success
      response.body.should == Topic.all.to_json
    end
  end
end
