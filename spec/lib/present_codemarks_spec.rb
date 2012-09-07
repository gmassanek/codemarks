require 'action_view'
require 'present_codemarks'

describe PresentCodemarks do
  let(:avatar_url) { 'http://localhost:3000/images/avatar.png' }
  let(:topic) { mock(
    id: 11,
    title: 'Rspec',
    slug: 'rspec'
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
  let(:link) { mock(
    id: 200,
    host: 'www.github.com',
    url: 'www.github.com/gmassanek',
    resource_type: 'link'
  )}
  let(:text_record) { mock(
    id: 201,
    text: 'A brilliant idea',
    resource_type: 'text'
  )}
  let(:comment) { mock(
    author: author
  )}
  let(:comments) { [comment] }
  let(:codemark) { mock(
    id: 1,
    title: 'The Best Resource Ever',
    topics: topics,
    resource: link,
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
      codemarks.stub(:num_pages => 1)
      PresentCodemarks.should_receive(:present).with(codemark, author).twice
      data = PresentCodemarks.for(codemarks, author)
      data.length.should == 2
    end
  end

  describe '#present(codemark)' do
    it 'the codemark presents its attributes' do
      PresentCodemarks.stub(:tweet_link) { 'some crazy link' }

      cm = PresentCodemarks.present(codemark, author)
      cm[:id].should == 1
      cm[:resource][:title].should == {
        content: 'The Best Resource Ever',
        href: link.url
      }
      cm[:twitter_share].should_not be_nil
      cm[:show_comments].should == 'Comments (1)'
      cm[:save_date].should == 'about 2 hours ago'
      cm[:mine].should == true
      cm[:corner].should == {
        :class => 'delete',
        :content => ''
      }
      cm[:actions].should == { :copy => nil }
      cm[:author].should == {:name=>"tim-timothy", :avatar=>{:content=>"", :src=>"http://localhost:3000/images/avatar.png"}}
      cm[:topics].should == [{:id=>11, :topic_title=>{:content=>"Rspec", :href=>"/topics/1"}}, {:id=>11, :topic_title=>{:content=>"Rspec", :href=>"/topics/1"}}]
      cm[:resource].should == {:id=>200, :type=>"link", :host=>"www.github.com", :url=>"www.github.com/gmassanek", :title=>{:content=>"The Best Resource Ever", :href=>"www.github.com/gmassanek"}}
    end
  end

  describe '#present_resource' do
    it 'presents a text_record' do
      codemark.stub(:resource => text_record)
      PresentCodemarks.should_receive(:present_text_record).with(codemark, text_record).and_return({})
      data = PresentCodemarks.present_resource(codemark)
    end

    it 'presents a link_record' do
      PresentCodemarks.should_receive(:present_link_record).with(codemark, link).and_return({})
      data = PresentCodemarks.present_resource(codemark)
    end

    it 'presents the id and title' do
      PresentCodemarks.stub(:present_link_record) { {} }
      data = PresentCodemarks.present_resource(codemark)
      data[:id].should == link.id
      data[:type].should == 'link'
    end
  end

  describe '#present_topic_record' do
    it 'presents text' do
      codemark.stub(:resource => text_record)
      data = PresentCodemarks.present_resource(codemark)
      data[:text].should == text_record.text
    end
  end

  describe '#present_link_record' do
    it 'presents text' do
      data = PresentCodemarks.present_resource(codemark)
      data[:host].should == link.host
      data[:url].should == link.url
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

  describe '#mine' do
    it 'is true if the codemark user is the current user' do
      PresentCodemarks.mine?(codemark, author).should be_true
    end

    it 'is false if the codemark user is not the current user' do
      PresentCodemarks.mine?(codemark, stub).should be_false
    end
  end

  describe '#mine' do
    it 'nulls out copy for an existing resource' do
      PresentCodemarks.actions(true).should == {
        :copy => nil
      }
    end

    it 'nulls out edit for a new resource' do
      PresentCodemarks.actions(false).should == {
        :edit => nil
      }
    end
  end
end
