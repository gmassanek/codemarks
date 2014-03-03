require 'spec_helper'

describe Filemark do
  it 'will create a file' do
    Filemark.create!(:file => File.open('spec/fixtures/images/test.png', 'w'))
  end

  it 'does not allow files larger than 2MB' do
    file = Filemark.new(:file => File.open('spec/fixtures/images/test.png', 'w'))
    file.stub(:attachment_file_size => 2.megabytes + 10)
    file.save
    file.errors.should include(:attachment)
  end
end
