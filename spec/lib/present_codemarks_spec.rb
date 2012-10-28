require 'spec_helper'

describe PresentCodemarks do
  let(:codemark) { Fabricate(:codemark_record) }

  it 'presents everything it needs to' do
    codemark.title = nil
    presented = PresentCodemarks.present(codemark)
    data = codemark.resource.attributes
    data.delete('site_data')
    presented[:resource].should == data
    presented['title'].should == codemark.title
  end
end
