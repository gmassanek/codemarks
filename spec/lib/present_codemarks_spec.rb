require 'present_codemarks'

describe PresentCodemarks do
  describe '## for' do
    it 'has a list of codemarks' do
      codemarks = []
      data = PresentCodemarks.for(codemarks)
      data.should include(:codemarks)
    end

    describe 'responds with errors' do
      it 'to empty input'
    end
  end
end
