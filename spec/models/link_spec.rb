require 'spec_helper'

describe Link do
  let(:valid_url) { "http://www.example.com" }
  let(:link) { Link.create!(:url => valid_url) }

  required_attributes = [:url]
  required_attributes.each do |attr|
    it "requires a #{attr}" do
      link = Fabricate.build(:link, attr => nil)
      link.should_not be_valid
    end
  end

  it 'accepts attrs' do
    link.url.should == valid_url
  end

  it 'defaults the title' do
    link.title.should == '(No title)'
  end

  describe "#suggested_topics" do
    before do
      @link = Link.new
      @github = Topic.create!(:title => 'Github')
      @rspec = Topic.create!(:title => 'rspec')
      @google = Topic.create!(:title => 'google')
      @book = Topic.create!(:title => 'book')
    end

    it "could get all #{Link::TAG_SUGGESTION_LIMIT} from the title" do
      @link.assign_attributes(:title => 'Github rspec google')
      @link.suggested_topics.map(&:slug).should =~ [@github.slug, @rspec.slug, @google.slug]
    end

    it "could get some from the title and some from site_data" do
      @link.assign_attributes(:title => 'Github rspec', :site_data => 'book')
      @link.suggested_topics.map(&:slug).should =~ [@github.slug, @rspec.slug, @book.slug]
    end

    it "could all from site_data" do
      @link.assign_attributes(:site_data => 'Github rspec book')
      @link.suggested_topics.map(&:slug).should =~ [@github.slug, @rspec.slug, @book.slug]
    end

    it "never duplicates topics" do
      @link.assign_attributes(:title => 'Github rspec', :site_data => 'Github book')
      @link.suggested_topics.map(&:slug).should =~ [@github.slug, @rspec.slug, @book.slug]
    end

    it "limits to #{Link::TAG_SUGGESTION_LIMIT} topics" do
      @link.assign_attributes(:title => 'Github github rspec rspec google book')
      @link.suggested_topics.map(&:slug).should =~ [@github.slug, @rspec.slug, @google.slug]
    end
  end
end
