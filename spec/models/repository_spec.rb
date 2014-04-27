require 'spec_helper'

describe Repository do
  describe "#suggested_topics" do
    before do
      @repo = Repository.new
      @rspec = Topic.create!(:title => 'rspec')
      @ruby = Topic.create!(:title => 'ruby')
    end

    it "matches any topic for the title" do
      @repo.assign_attributes(:title => 'rspec')
      @repo.suggested_topics.map(&:slug).should =~ [@rspec.slug]
    end

    it "creates a topic for the title" do
      @repo.assign_attributes(:title => 'codemarks')
      @repo.suggested_topics.map(&:slug).should =~ ['codemarks']
    end

    it "matches any topic for the language" do
      @repo.assign_attributes(:language => 'Ruby')
      @repo.suggested_topics.map(&:slug).should =~ [@ruby.slug]
    end

    it "creates a topic for the language" do
      @repo.assign_attributes(:language => 'Java')
      @repo.suggested_topics.map(&:slug).should =~ ['java']
    end

    it "tags the description" do
      @repo.assign_attributes(:title => 'rspec', :description => 'A testing framework for ruby')
      @repo.suggested_topics.map(&:slug).should =~ [@rspec.slug, @ruby.slug]
    end

    it "never duplicates topics" do
      @repo.assign_attributes(:title => 'rspec', :description => 'rspec')
      @repo.suggested_topics.map(&:slug).should =~ [@rspec.slug]
    end

    it "limits to #{Tagger::TAG_SUGGESTION_LIMIT} tags" do
      Topic.create!(:title => 'foo')
      Topic.create!(:title => 'bar')
      Topic.create!(:title => 'baz')
      Topic.create!(:title => 'foo1')
      Topic.create!(:title => 'bar1')
      Topic.create!(:title => 'baz1')

      @repo.assign_attributes(:title => 'rspec', :description => 'foo bar baz foo1 bar1 baz1')
      @repo.suggested_topics.map(&:slug).should =~ [@rspec.slug, 'foo', 'bar']
    end
  end
end
