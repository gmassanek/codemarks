require 'spec_helper'

describe PresentCodemarks do
  let(:codemark) { Fabricate(:codemark_record) }

  it 'presents everything it needs to' do
    codemark.title = nil
    presented = PresentCodemarks.present(codemark)
    presented[:resource].should == codemark.resource.attributes
    presented['title'].should == codemark.title
  end
end
