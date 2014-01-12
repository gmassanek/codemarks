require 'spec_helper'

describe PresentCodemarks do
  let(:user) { Fabricate(:user) }
  let(:link) { Fabricate(:link) }
  let(:codemark) { Fabricate(:codemark, :resource => link, :user => user) }

  it 'presents everything it needs to' do
    data = PresentCodemarks.present(codemark)
    data['id'].should == codemark.id
    data['user_id'].should == codemark.user_id
    data['resource_id'].should == codemark.resource_id
    data['resource_type'].should == codemark.resource_type
    data['created_at'].should == codemark.created_at
    data['updated_at'].should == codemark.updated_at
    data['description'].should == codemark.description
    data['title'].should == codemark.title
    data['group_id'].should == codemark.group_id
  end

  it 'presents a link codemarks' do
    data = PresentCodemarks.present(codemark)[:resource]
    data['url'].should == codemark.resource.url
  end

  it 'presents a text codemarks' do
    text = Text.create(:text => '## text')
    codemark = Fabricate(:codemark, :resource => text, :user => user)
    data = PresentCodemarks.present(codemark)[:resource]
    data['text'].should == '## text'
    data['html'].should == "<h2>text</h2>\n"
  end

  it 'presents pagination' do
    data = PresentCodemarks.for(Kaminari.paginate_array([codemark]).page(1))
    data[:pagination].should be_present
  end

  it 'presents users' do
    data = PresentCodemarks.for(Kaminari.paginate_array([codemark]).page(1))
    data[:users].should be_present
  end
end
