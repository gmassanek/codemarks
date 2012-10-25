require 'spec_helper'

describe Comment do
  let(:comment) { Comment.new(
    :codemark_id => 3,
    :author_id => 83,
    :text => 'Nice one'
  )}

  it 'requires an codemark_id' do
    comment.codemark_id = nil
    comment.should_not be_valid
  end

  it 'requires an author_id' do
    comment.author_id = nil
    comment.should_not be_valid
  end

  it 'requires some text' do
    comment.text = nil
    comment.should_not be_valid
  end
end
