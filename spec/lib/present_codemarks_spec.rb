module ActionView
  module Helpers
    module DateHelper; end
  end
end

require 'present_codemarks'

describe PresentCodemarks do
  let(:avatar_url) { 'http://localhost:3000/images/avatar.png' }
  let(:topic) { mock(
    id: 11,
    title: 'Rspec'
  )}
  let(:topics) { [topic, topic] }
  let(:author) { mock(
    :image => avatar_url,
    :get => avatar_url,
    :nickname => 'tim-timothy'
  )}
  let(:save) { mock(
    author: author,
    save_date: Date.new
  )}
  let(:resource) { mock(
    host: 'www.github.com'
  )}
  let(:comment) { mock(
    author: author
  )}
  let(:comments) { [comment] }
  let(:codemark) { mock(
    id: 1,
    title: 'The Best Resource Ever',
    topics: topics,
    resource: resource,
    created_at: Time.now,
    user: author,
    comments: comments
  )}

  before do
    PresentCodemarks.stub(:codemark_path) { '/codemark/1' }
    PresentCodemarks.stub(:topic_path) { '/topics/1' }
    PresentCodemarks.stub(:time_ago) { '2 hours' }
  end

  describe '## for' do
    it 'has a list of codemarks' do
      codemarks = [codemark, codemark]
      PresentCodemarks.should_receive(:present).with(codemark).twice
      data = PresentCodemarks.for(codemarks)
      data.length.should == 2
    end
  end

  describe '#present(codemark)' do
    it 'the codemark presents its attributes' do
      PresentCodemarks.stub(:present_resource) { resource }
      PresentCodemarks.stub(:present_topics) { topics }
      PresentCodemarks.stub(:present_author) { author }
      PresentCodemarks.stub(:tweet_link) { 'some crazy link' }
      PresentCodemarks.stub(:current_user) { author }
      cm = PresentCodemarks.present(codemark)
      cm[:id].should == 1
      cm[:title].should == {
        content: 'The Best Resource Ever',
        href: '/codemark/1'
      }
      cm[:twitter_share].should_not be_nil
      cm[:show_comments].should == 'Comments (1)'
      cm[:save_date].should == 'about 2 hours ago'
      cm[:mine].should == true
      cm[:corner].should == {
        :class => 'delete',
        :content => ''
      }
      cm[:author].should == author
      cm[:topics].should == topics
      cm[:resource].should == resource
    end
  end

  describe '#present_resource' do
    it 'presents everything' do
      data = PresentCodemarks.present_resource(resource)
      data[:host].should == resource.host
    end
  end

  describe '#present_topic' do
    it 'presents everything' do
      data = PresentCodemarks.present_topic(topic)
      data[:id].should == topic.id
      data[:topic_title][:content].should == topic.title
      data[:topic_title][:href].should_not be_nil # should actually assert the value
    end
  end

  describe '#present_author' do
    it 'presents everything' do
      data = PresentCodemarks.present_author(author)
      data[:name].should == author.nickname
      data[:avatar][:content].should == ''
      data[:avatar][:src].should == avatar_url
    end
  end

  describe '#present_comment' do
    it 'presents everything' do
      PresentCodemarks.stub(:present_author) { author }
      data = PresentCodemarks.present_comment(comment)
      data[:author].should == author
    end
  end

  describe 'responds with errors' do
    it 'to empty input'
  end
end
