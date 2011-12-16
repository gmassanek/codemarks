require 'spec_helper'

describe Codemark do
  context "requires" do
    [:link, :user].each do |field|
      it "a #{field}" do
        codemark = Fabricate.build(:codemark, field => nil)
        codemark.should_not be_valid
      end
    end
  end
  
  it "is unarchived by default" do
    Codemark.new.should_not be_archived
  end

  it "retrieves unarchived link saves" do
    new_ls = Fabricate(:codemark, archived: false)
    old_ls = Fabricate(:codemark, archived: true)
    Codemark.unarchived.should == [new_ls]
  end

  it "sorts by save date" do
    old_ls = Fabricate(:codemark, :created_at => 3.years.ago)
    new_ls = Fabricate(:codemark, :created_at => 3.minutes.ago)
    med_ls = Fabricate(:codemark, :created_at => 3.days.ago)
    Codemark.by_save_date.should == [new_ls, med_ls, old_ls]
  end

  it "sorts by popularity" do
    boring = Fabricate(:codemark)
    3.times { Fabricate(:click, link: boring.link) }
    popular = Fabricate(:codemark)
    9.times { Fabricate(:click, link: popular.link) }
    pretty_good = Fabricate(:codemark)
    5.times { Fabricate(:click, link: pretty_good.link) }

    Codemark.by_popularity.should == [popular, pretty_good, boring]
  end

  it "delegates title and url to it's link" do
    codemark = Fabricate.build(:codemark)
    link = codemark.link
    codemark.title.should == link.title
    codemark.url.should == link.url
  end

  it "has topics through codemarks (link saves)" do
    codemark = Fabricate(:codemark)
    codemark.topics.should_not be_blank
  end

  it "creates CodemarkTopics on save" do
    codemark = Fabricate.build(:codemark)
    topics = [Fabricate(:topic), Fabricate(:topic)]
    codemark.topics = topics
    lambda {
      codemark.save
    }.should change(CodemarkTopic, :count).by(topics.count)
  end

  it "creates CodemarkTopics on update" do
    codemark = Fabricate.build(:codemark)
    topics = [Fabricate(:topic), Fabricate(:topic)]
    codemark.topics = topics
    codemark.save

    topics << Fabricate(:topic)
    codemark.topics = topics
    codemark.save!

    CodemarkTopic.count.should == 3
  end

  it "deletes CodemarkTopics on update" do
    codemark = Fabricate.build(:codemark)
    topics = [Fabricate(:topic), Fabricate(:topic)]
    codemark.topics = topics
    codemark.save

    codemark.topics = [topics.first]
    codemark.save!

    CodemarkTopic.count.should == 1
    Codemark.find(codemark.id).topics.count.should == 1
  end

  it "creates new topics for any that don't exist yet" do
    codemark = Fabricate.build(:codemark)
    hats = Fabricate.build(:topic, :title => "Hats that I want")
    topics = codemark.topics
    topics << hats
    
    lambda {
      codemark.save!
    }.should change(Topic, :count).by(1)
  end

  it "finds all codemarks for a link" do
    codemark = Fabricate(:codemark)
    codemark2 = Fabricate(:codemark, link: codemark.link)
    Codemark.for(codemark.link).should == [codemark, codemark2]
  end
end
