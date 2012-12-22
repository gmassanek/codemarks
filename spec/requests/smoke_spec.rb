require 'spec_helper'

describe 'Smoke Tests' do
  it 'routes the homepage to the codemarks index' do
    CodemarksController.any_instance.should_receive(:index)
    get root_path
    response.should be_success
  end
end
