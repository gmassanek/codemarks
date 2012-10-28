Given /^I add the 'private' tag$/ do
  select('private', :from => 'topics')
end

Given /^I have a private codemark$/ do
  @codemark = Fabricate(:codemark_record, :topics => [@private], :user => @current_user)
end

Given /^another user has a private codemark$/ do
  @user = Fabricate(:user)
  @codemark = Fabricate(:codemark_record, :user => @user, :private => true)
end

Given /^a private tag exists$/ do
  @private = Topic.find_by_title('private')
  @private = Fabricate(:topic, :title => 'private') unless @private
end

Then /^that codemark should be private$/ do
  twitter = CodemarkRecord.last
  twitter.should be_private
end
