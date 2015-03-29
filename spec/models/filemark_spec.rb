require 'spec_helper'

describe Filemark do
  it 'does not allow files larger than 2MB' do
    file = Filemark.new(:attachment => File.open('spec/fixtures/images/test.png', 'w'))
    file.stub(:attachment_file_size => 2.megabytes + 10)
    file.save
    file.errors.should include(:attachment)
  end
end
