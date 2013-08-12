Given /^I have a private codemark$/ do
  @codemark = Fabricate(:codemark, :topics => [@private], :user => @current_user)
end

Given /^another user has a private codemark$/ do
  @codemark = Fabricate(:codemark, :user => Fabricate(:user), :topics => [@private])
end

Given /^a private tag exists$/ do
  @private = Topic.find_by_title('private') || Fabricate(:topic, :title => 'private')
end

Then /^that codemark should be private$/ do
  cm = Codemark.last
  cm.should be_private
end
