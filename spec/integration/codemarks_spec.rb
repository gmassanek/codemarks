require 'spec_helper'

describe 'Codemark lists' do
  describe '/public' do
    context 'as html' do
      it 'works' do
        get public_codemarks_path
        response.should be_success
      end

      it 'does not load any codemarks yet' do
        FindCodemarks.should_not_receive(:new)
        get public_codemarks_path
      end

      xit 'finds the codemarks that exist' do
        # create some codemarks
        # assert that they're there
      end
    end

    context 'as json' do
      it 'works' do
        get public_codemarks_path, :format => :json
        response.should be_success
      end

      it 'loads up some codemarks' do
        FindCodemarks.should_receive(:new)
        get public_codemarks_path, :format => :json
      end

      xit 'finds the codemarks that exist' do
        # create some codemarks
        # assert that they're there
      end
    end
  end
end
