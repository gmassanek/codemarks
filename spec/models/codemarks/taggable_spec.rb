require_relative '../../../app/models/codemarks/taggable'

class SomethingTaggable
  include Codemarks::Taggable
end

describe Codemarks::Taggable do
  it "is taggable" do
    SomethingTaggable.should be_taggable
  end
  it "is taggable" do
    SomethingTaggable.new.should be_taggable
  end
end
