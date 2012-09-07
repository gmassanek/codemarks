require 'spec_helper'

describe CodemarkFormsController do
  describe '#text' do
    it 'responds successfully with an html form' do
      get 'codemark_forms/text'
      response.should be_success
      response.content_type.should == 'html'
    end

    it 'sets the a new codemark' do
      get 'codemark_forms/text'
      assigns(:codemark).should be_present
    end

    # SOMETHING IS WEIRD ABOUT THISSSS
    xit 'sets the saver_id if it exists' do
      CodemarkFormsController.should_receive(:load_user).with(5)
      get 'codemark_forms/text', :saver => '5'
      assigns(:saver).should be_present
    end
  end

  it 'handles errors appropriates'
end

