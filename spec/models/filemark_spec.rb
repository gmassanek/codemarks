require 'spec_helper'

describe Filemark do
  it 'works' do
    Filemark.create!(:file => File.open('tmp/test.html', 'w'))
  end
end
