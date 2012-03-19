require 'spec_helper'

describe "Can build codemarks" do

  it "hits the internet to save a link for a new link" do
    codemark = Codemark.load(:url => 'http://www.google.com')
    codemark.resource.url.should == 'http://www.google.com'
    codemark.resource.html_content.should_not be_nil
  end

  it "has tags" do
    google = Topic.create(:title => "Google")
    codemark = Codemark.load(:url => 'http://www.google.com')
    codemark.tags.should == [google]
  end

  it "adds any new topics to the tag_id list" do
    user = Fabricate(:user)
    codemark = Codemark.save({:url => 'http://www.google.com'}, [], :new_topics => ['Rspec', 'Search'], :user_id => user.id)

    codemark2 = Codemark.save({:url => 'http://www.google.com'}, codemark.tag_ids, :new_topics => ['this', 'that'], :user_id => user.id)
    codemark2.tag_ids.length.should == 4
  end

  it "persists the codemark" do
    user = Fabricate(:user)
    google = Topic.create(:title => "Google")
    codemark = Codemark.load(:url => 'http://www.google.com', :user => user)
    lambda {
      codemark.save
    }.should change(CodemarkRecord, :count)

    codemark.id.should_not be_nil
  end

  it "updates existing codemarks" do
    user = Fabricate(:user)
    google = Topic.create(:title => "Google")
    codemark = Codemark.load(:url => 'http://www.google.com', :user => user)
    codemark.save
    codemark.id = nil

    lambda {
      codemark.save
    }.should_not change(CodemarkRecord, :count)
  end

  it "persists a link" do
    lambda {
      Codemark.load(:url => "http://www.google.com")
    }.should change(LinkRecord, :count)
  end

  it "uses existing links" do
    link = Link.load(url: "http://www.google.com")

    lambda {
      Codemark.load(:url => "http://www.google.com")
    }.should_not change(LinkRecord, :count)
  end

  it "suggests the topic from an existing codemark of the same resource" do
    user = Fabricate(:user)
    codemark = Codemark.save({:url => 'http://www.google.com'}, [], :new_topics => ['Rspec', 'Search'], :user_id => user.id)

    another_user = Fabricate(:user)
    new_codemark = Codemark.load(:url => 'http://www.google.com', :user_id => user.id)
    new_codemark.tags.should == codemark.tags
  end
end

