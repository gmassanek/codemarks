require 'spec_helper'

describe CodemarksController do
  context 'text codemarks' do
    before do
      @params = {
        :type => 'text',
        :saver_id => 1,
        :resource => { 'text' => 'I think I should write one about this topic', },
        :codemark => { 'title' => 'Blog post idea' }
      }
    end

    it 'creates a resource' do
      post 'codemarks', {:format => :js}.merge(@params)
    end
  end

  context 'link codemarks' do
    before do
      @params = {
        :type => 'text',
        :saver_id => 1,
        :resource => { 'url' => 'I think I should write one about this topic' },
        :codemark => { 'title' => 'Blog post idea' }
      }
    end

    it 'passes back save failures'

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
