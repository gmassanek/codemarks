require_relative '../../app/lib/taggable'

class TaggableObject
  include Taggable
end

describe Taggable do
  let(:taggable_instance) { TaggableObject.new }

  it "has a tag limit of 5" do
    Taggable::TAG_LIMIT.should == 5
  end

  describe "#tags" do
    it "from it's tags instance variable first" do
      tags = []
      taggable_instance.stub(:existing_tags) { (tags) }
      taggable_instance.should_not_receive(:find_existing_tags)
      taggable_instance.tags.should == tags
    end

    it "then from existing tags" do
      tags = stub
      taggable_instance.stub(:find_existing_tags) { tags }
      taggable_instance.tags.should == tags
    end

    it "or finally from it's attributes none already existed" do
      tags = stub
      taggable_instance.stub(:find_existing_tags) { nil }
      taggable_instance.stub(:retag) { tags }
      taggable_instance.tags.should == tags
    end
  end

  describe "#retag" do
    it "tags it's attributes in order" do
      taggable_instance.stub({
        :title => 'Rspec Tricks',
        :body  => 'blah blah blah'
      })
      taggable_instance.stub(:tagging_order) { [:title, :body] }

      taggable_instance.should_receive(:tag).with('Rspec Tricks').once.ordered
      taggable_instance.should_receive(:tag).with('blah blah blah').once.ordered
      taggable_instance.retag
    end

    it "in the default order (in case it's class forgot)"

    it "won't return more than #{Taggable::TAG_LIMIT}" do
      taggable_instance.stub({
        :title => "Rspec",
        :tagging_order => [:title],
        :tag => [:one, :two, :three, :four, :five, :six]
      })

      taggable_instance.retag.should == [:one, :two, :three, :four, :five]
    end

    it "stops asking for tags if it's already found #{Taggable::TAG_LIMIT}" do
      taggable_instance.stub({
        :title => "Rspec",
        :body => "blah blah blah",
        :tagging_order => [:title, :body]
      })

      taggable_instance.should_receive(:tag)
        .with("Rspec").and_return([:one, :two, :three, :four, :five])

      taggable_instance.should_not_receive(:tag).with("blah blah blah")
      taggable_instance.retag.should == [:one, :two, :three, :four, :five]
    end

    it "combinines tags from multiple attributes" do
      taggable_instance.stub({
        :title => "Rspec",
        :body => "blah blah blah",
        :tagging_order => [:title, :body]
      })

      taggable_instance.should_receive(:tag)
        .with("Rspec").and_return([:one, :two])

      taggable_instance.should_receive(:tag)
        .with("blah blah blah").and_return([:three, :four])

      taggable_instance.retag.should == [:one, :two, :three, :four]
    end

    it "has no duplicates" do
      taggable_instance.stub({
        :title => "Rspec",
        :body => "blah blah blah",
        :tagging_order => [:title, :body]
      })

      taggable_instance.should_receive(:tag)
        .with("Rspec").and_return([:one, :two])

      taggable_instance.should_receive(:tag)
        .with("blah blah blah").and_return([:one, :three])

      taggable_instance.retag.should == [:one, :two, :three]
    end

  end
end
