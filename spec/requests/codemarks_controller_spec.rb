require 'spec_helper'

describe CodemarksController do
  context 'text codemarks' do
    before do
      @params = {
        :type => 'text',
        :resource => {
          'text' => 'I think I should write one about this topic',
          :saver_id => 1
        },
        :codemark => {
          'title' => 'Blog post idea',
        }
      }
    end

    it 'creates a resource' do
      #Resource.should_receive(:create!).and_return(mock(:id => 5))
      post 'codemarks', {:format => :js}.merge(@params)
    end



    xit 'does not break with perfect input' do
      @resource = Fabricate(:link_record)
      @attributes = {
        :resource_id => @resource.id
      }
      @params = {
        :codemark => @attributes
      }
      topics = [Fabricate(:topic), Fabricate(:topic)]
      @topic_info = { }
      topics.each { |t| @topic_info[t.id] = [t.id] }
      user = stub(:id => 11)
      controller.stub!(:current_user_id => user.id)

      @topic_ids = { 'woo' => 'woo'}
      post :create, :format => :js, :codemark => @attributes, :topic_info => @topic_info, :topic_ids => @topic_ids
    end
  end
end
