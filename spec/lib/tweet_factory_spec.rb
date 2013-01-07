require 'spec_helper'

describe TweetFactory do
  describe '#codemark_of_the_day' do
    it 'includes "Codemark of the Day!' do
      codemark = Fabricate(:codemark_record)
      TweetFactory.codemark_of_the_day(codemark).should include('Codemark of the Day!')
    end

    it 'contains a link' do
      codemark = Fabricate(:codemark_record)
      TweetFactory.codemark_of_the_day(codemark).should include('http')
    end

    it 'contains "via @codemarks"' do
      codemark = Fabricate(:codemark_record)
      TweetFactory.codemark_of_the_day(codemark).should include('via')
      TweetFactory.codemark_of_the_day(codemark).should include('@codemarks')
    end

    it 'should not contain two consecutive spaces' do
      codemark = Fabricate(:codemark_record)
      TweetFactory.codemark_of_the_day(codemark).should_not include '  '
    end

    it 'includes topics if there is room' do
      topic = Fabricate(:topic, :title => 'github')
      codemark = Fabricate(:codemark_record, :title => 'Check this out')
      TweetFactory.codemark_of_the_day(codemark).should_not include '#github'
    end
  end
end
