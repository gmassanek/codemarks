require 'fast_helper'

class Topic; end

describe Tagger do
  describe '#tag' do
    let(:titles) { ['rspec', 'github', 'google', 'cucumber', 'jquery', 'another item'] }
    let(:topics) { titles.map { |title| stub(:title => title) } }

    before do
      Topic.stub!(:all => topics)
    end

    it 'returns all the topics that are in the text' do
      text = 'rspec stuff'
      rspec = topics.first
      Tagger.tag(text).should == [rspec]
    end

    it 'returns an empty array if the text is blank' do
      text = ''
      rspec = topics.first
      Tagger.tag(text).should == []
    end

    it 'returns an empty array if the text is nil' do
      text = nil
      rspec = topics.first
      Tagger.tag(text).should == []
    end

    it 'matches regardless of case' do
      rspec = topics.first
      text = rspec.title.upcase
      Tagger.tag(text).should == [rspec]
    end
  end
end
