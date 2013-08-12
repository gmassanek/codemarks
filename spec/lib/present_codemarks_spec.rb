require 'spec_helper'

describe PresentCodemarks do
  let(:user) { Fabricate(:user) }
  let(:link) { Fabricate(:link) }
  let(:codemark) { Fabricate(:codemark, :resource => link, :user => user) }

  it 'presents everything it needs to' do
    codemark.title = nil
    presented = PresentCodemarks.present(codemark)
    data = codemark.resource.attributes
    data.delete('site_data')
    presented[:resource].should == data
    presented['title'].should == codemark.title
  end

  it 'presents pagination' do
    presented = PresentCodemarks.for(Kaminari.paginate_array([codemark]).page(1))
    presented[:pagination].should be_present
  end

  it 'presents users' do
    presented = PresentCodemarks.for(Kaminari.paginate_array([codemark]).page(1))
    presented[:users].should be_present
  end
end
