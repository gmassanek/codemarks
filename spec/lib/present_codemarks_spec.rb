require 'present_codemarks'

describe PresentCodemarks do
  describe '## for' do
    let(:topics) { [mock, mock] }
    let(:save) { mock(
      author: 'gmassanek',
      save_date: Date.new
    )}
    let(:codemark) { mock(
      id: 1,
      title: 'The Best Resource Ever',
      topics: topics,
      #first_save: save,
      #last_save: save
    )}

    before do
      PresentCodemarks.stub(:topic_path) { '/topics/1' }
    end

    it 'has a list of codemarks' do
      codemarks = [codemark, codemark]
      PresentCodemarks.should_receive(:present).with(codemark).twice
      data = PresentCodemarks.for(codemarks)
      data.length.should == 2
    end

    describe '#present(codemark)' do
      it 'the codemark presents its attributes' do

        cm = PresentCodemarks.present(codemark)
        cm[:id].should == 1
        cm[:title].should == {
          content: 'The Best Resource Ever',
          href: '/topics/1'
        }
        cm[:topics].should == topics
        #cm[:first_save].should == save
        #cm[:last_save].should == save
      end
    end

    describe 'responds with errors' do
      it 'to empty input'
    end
  end
end
