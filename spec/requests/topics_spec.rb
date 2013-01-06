require 'spec_helper'

describe TopicsController do
  describe '#index' do
    it 'serves all existing topics in JSON' do
      Fabricate(:topic)
      Fabricate(:topic)
      get topics_path
      response.should be_success
      JSON.parse(response.body).should have(Topic.count).items
    end
  end
end
