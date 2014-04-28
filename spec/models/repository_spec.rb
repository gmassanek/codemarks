require 'spec_helper'

describe Repository do
  describe '.create_from_url' do
    it 'returns nil for invalid urls' do
      Repository.create_from_url('https://developer.github.com/v3/repos/#get').should == nil
    end

    it 'returns an existing repo if there is one' do
      existing_repo = Repository.create!(:owner_login => 'gmassanek', :title => 'codemarks')
      repo = Repository.create_from_url('https://github.com/gmassanek/codemarks')
      existing_repo.id.should == repo.id
    end

    it 'creates a new repository from gitbub' do
      VCR.use_cassette :get_github_repository, :match_requests_on => [:host, :path] do
        repo = Repository.create_from_url('https://github.com/gmassanek/codemarks')
        repo.should be_persisted
        repo.owner_login.should == 'gmassanek'
        repo.title.should == 'codemarks'
        repo.language.should == 'Ruby'
      end
    end
  end

  describe '#refresh_remote_data!' do
    it 'returns false if remote call failed' do
      VCR.use_cassette :get_github_repository_failed, :match_requests_on => [:host, :path] do
        repo = Repository.new(:owner_login => 'gmassanek', :title => 'codemarks')
        repo.refresh_remote_data!.should == false
      end
    end

    it 'returns false if the data url cannot be created' do
      repo = Repository.new(:owner_login => nil, :title => 'codemarks')
      repo.refresh_remote_data!.should == false
    end

    it 'refreshes its data from a remote call' do
      VCR.use_cassette :get_github_repository, :match_requests_on => [:host, :path] do
        repo = Repository.new(:owner_login => 'gmassanek', :title => 'codemarks')
        repo.refresh_remote_data!

        repo.owner_login.should == 'gmassanek'
        repo.title.should == 'codemarks'
        repo.language.should == 'Ruby'
      end
    end
  end

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
