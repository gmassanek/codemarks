Given /^there (is|are) (\d+) comment(s) for that codemark's resource$/ do |_, num_comments, _|
  @comments = []
  num_comments.to_i.times do  |i|
    @comments << Comment.build_from(@codemark.resource, Fabricate(:user), "Comment #{i}")
  end
  @comments.map(&:save)
end

Given /^I made (\d+) comment for that codemark's resource$/ do |num_comments|
  @comments = []
  num_comments.to_i.times do  |i|
    @comments << Comment.build_from(@codemark.resource, @current_user.id, "Comment #{i}")
  end
  @comments.map(&:save)
end

Then /^I should see those comments$/ do
  @comments.each do |comment|
    page.should have_content(comment.body)
  end
end

Then /^I should be able to comment on that codemark's resoure$/ do
  page.fill_in "comment[body]", :with => 'Some new comment'
  page.find('.save_comment').click
  step 'I wait until all Ajax requests are complete'

  page.should have_content(@codemark.resource.comment_threads.last.body)
end

Then /^I should be able to delete my comment$/ do
  expect {
    page.find('.delete-comment').trigger('click')
    step 'I wait until all Ajax requests are complete'
  }.to change(Comment, :count).by(-1)
end

Then /^I should not be able to delete that comment$/ do
  page.should_not have_selector('.delete-comment')
end
