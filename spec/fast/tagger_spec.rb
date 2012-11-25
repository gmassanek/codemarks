require 'fast_helper'

class Topic; end

describe Tagger do
  describe '#tag' do
    let(:titles) { ['rspec', 'git', 'github', 'google', 'cucumber', 'jquery', 'another item'] }
    let(:topics) { titles.map { |title| stub(:title => title) } }

    before do
      Topic.stub!(:all => topics)
      @rspec = topics.find { |t| t.title == 'rspec' }
      @github = topics.find { |t| t.title == 'github' }
      @jquery = topics.find { |t| t.title == 'jquery' }
    end

    it 'returns all the topics that are in the text' do
      text = 'rspec stuff'
      Tagger.tag(text).should == [@rspec]
    end

    it 'returns an empty array if the text is blank' do
      text = ''
      Tagger.tag(text).should == []
    end

    it 'returns an empty array if the text is nil' do
      text = nil
      Tagger.tag(text).should == []
    end

    it 'matches regardless of case' do
      text = @rspec.title.upcase
      Tagger.tag(text).should == [@rspec]
    end

    it 'does not match sub words' do
      Tagger.tag('Github').count.should == 1
    end

    it 'orders them by their frequency' do
      text = ['rspec', 'jquery', 'jquery', 'jquery', 'github', 'github'].join(' ')
      Tagger.tag(text).map(&:title).should == ['jquery', 'github', 'rspec']
    end
  end
end
