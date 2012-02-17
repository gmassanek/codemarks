require 'spec_helper'

describe CodemarkRecord do
  context "requires" do
    [:link_record, :user].each do |field|
      it "a #{field}" do
        codemark = Fabricate.build(:codemark_record, field => nil)
        codemark.should_not be_valid
      end
    end
  end
  
  it "is unarchived by default" do
    Fabricate.build(:codemark_record).should_not be_archived
  end

  it "retrieves unarchived link saves" do
    new_ls = Fabricate(:codemark_record, archived: false)
    old_ls = Fabricate(:codemark_record, archived: true)
    CodemarkRecord.unarchived.should == [new_ls]
  end

  it "sorts by save date" do
    old_ls = Fabricate(:codemark_record, :created_at => 3.years.ago)
    new_ls = Fabricate(:codemark_record, :created_at => 3.minutes.ago)
    med_ls = Fabricate(:codemark_record, :created_at => 3.days.ago)
    CodemarkRecord.by_save_date.should == [new_ls, med_ls, old_ls]
  end

  it "sorts by popularity" do
    boring = Fabricate(:codemark_record)
    3.times { Fabricate(:click, link_record: boring.link_record) }
    popular = Fabricate(:codemark_record)
    9.times { Fabricate(:click, link_record: popular.link_record) }
    pretty_good = Fabricate(:codemark_record)
    5.times { Fabricate(:click, link_record: pretty_good.link_record) }

    CodemarkRecord.by_popularity.should == [popular, pretty_good, boring]
  end

  it "delegates title and url to it's link" do
    codemark = Fabricate.build(:codemark_record)
    link = codemark.link_record
    codemark.title.should == link.title
    codemark.url.should == link.url
  end

  it "has topics through codemarks (link saves)" do
    codemark = Fabricate(:codemark_record)
    codemark.topics.should_not be_blank
  end

  it "creates CodemarkTopics on save" do
    codemark = Fabricate.build(:codemark_record)
    topics = [Fabricate(:topic), Fabricate(:topic)]
    codemark.topics = topics
    lambda {
      codemark.save
    }.should change(CodemarkTopic, :count).by(topics.count)
  end

  it "creates CodemarkTopics on update" do
    codemark = Fabricate.build(:codemark_record)
    topics = [Fabricate(:topic), Fabricate(:topic)]
    codemark.topics = topics
    codemark.save

    topics << Fabricate(:topic)
    codemark.topics = topics
    codemark.save!

    CodemarkTopic.count.should == 3
  end

  it "deletes CodemarkTopics on update" do
    codemark = Fabricate.build(:codemark_record)
    topics = [Fabricate(:topic), Fabricate(:topic)]
    codemark.topics = topics
    codemark.save

    codemark.topics = [topics.first]
    codemark.save!

    CodemarkTopic.count.should == 1
    CodemarkRecord.find(codemark.id).topics.count.should == 1
  end

  it "creates new topics for any that don't exist yet" do
    codemark = Fabricate.build(:codemark_record)
    hats = Fabricate.build(:topic, :title => "Hats that I want")
    topics = codemark.topics
    topics << hats
    
    lambda {
      codemark.save!
    }.should change(Topic, :count).by(1)
  end

  it "finds all codemarks for a link" do
    codemark = Fabricate(:codemark_record)
    codemark2 = Fabricate(:codemark_record, link_record: codemark.link_record)
    CodemarkRecord.for(codemark.link_record).should == [codemark, codemark2]
  end
end
