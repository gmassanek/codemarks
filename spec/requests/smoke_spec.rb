require 'spec_helper'

describe 'Smoke Tests' do
  it 'routes the homepage to the codemarks index' do
    get root_path
    response.should be_redirect
    response.body.should include codemarks_path
  end
end
