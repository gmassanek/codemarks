Given /^I have a private codemark$/ do
  @codemark = Fabricate(:codemark_record, :topics => [@private], :user => @current_user)
end

Given /^another user has a private codemark$/ do
  @codemark = Fabricate(:codemark_record, :user => Fabricate(:user), :topics => [@private])
end

Given /^a private tag exists$/ do
  @private = Topic.find_by_title('private') || Fabricate(:topic, :title => 'private')
end

Then /^that codemark should be private$/ do
  cm = CodemarkRecord.last
  cm.should be_private
end
