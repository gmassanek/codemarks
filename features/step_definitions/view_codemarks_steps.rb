Given /^there are (\d+) random codemarks$/ do |num|
  @codemarks = []
  num.to_i.times do
    @codemarks << Fabricate(:codemark_record)
  end
end

Given /^someone else has codemarks$/ do
  2.times { Fabricate(:codemark_record) }
end

Given /^one of my codemarks has been save (\d+) other times$/ do |num|
  @codemark = @codemarks.first
  num.to_i.times do
    Fabricate(:codemark_record, :link_record => @codemark.link_record)
  end
end

Given /^I have a codemarks called "([^"]*)"$/ do |title|
  link_record = Fabricate(:link_record)
  @codemark = Fabricate(:codemark_record, :title => title, :link_record => link_record, :user => @current_user)
end

Given /^there are (\d+) codemarks for "([^"]*)"$/ do |num_codemarks, topic_title|
  @topic = Fabricate(:topic, :title => topic_title)
  num_codemarks.to_i.times do
    Fabricate(:codemark_record, :topic_ids => [@topic.id])
  end
end

Given /^([^"]*) is a user with a codemark$/ do |nickname|
  @user = Fabricate(:user)
  @user.update_attributes(:nickname => nickname)
  @codemark = Fabricate(:codemark_record, :user => @user)
  @topic = @codemark.topics.first
end

Given /^([^"]*) is a user with a codemark for that topic$/ do |nickname|
  @user = Fabricate(:user)
  @user.update_attributes(:nickname => nickname)
  @another_codemark = Fabricate(:codemark_record, :user => @user, :topic_ids => [@topic.id])
end

Given /^the last codemark doesn't have a link$/ do
  @codemarks.last.update_attribute(:link_record, nil)
end

Given /^I have a codemark with a note$/ do
  @codemark = Fabricate(:codemark_record, :note => 'I should use this on codemarks', :user => @current_user)
end

Given /^there is a codemark with a note$/ do
  @codemark = Fabricate(:codemark_record, :note => 'I should use this on codemarks')
end

Given /^there is a codemark with 2 comments$/ do
  @codemark = Fabricate(:codemark_record, :note => 'I should use this on codemarks')
  codemark_author = @codemark.user
  commentor = Fabricate(:user)
  @comment1 = Comment.create(:codemark_id => @codemark.id, :author => commentor, :text => 'Sick bro!')
  @comment2 = Comment.create(:codemark_id => @codemark.id, :author => commentor, :text => 'Thanks man')
end

Given /^I have commented on that codemark$/ do
  @my_comment = Comment.create(:codemark_id => @codemark.id, :author => @current_user, :text => 'Hootie Who')
end

When /^I click delete codemark$/ do
  within('.comments') do
    page.click_link('X')
  end
end

Then /^I should not see my new comment$/ do
  page.should have_selector('.comments li', :count => 2)
end

When /^I fill write a comment$/ do
  page.fill_in('comment_text', :with => 'Oh hello')
  page.click_button 'save'
end

Then /^I should see my new comment$/ do
  within('.comments') do
    page.should have_content('Oh hello')
  end
end

When /^I click on the comment icon$/ do
  page.driver.browser.execute_script("$('.actions').css('display', 'inline')")
  page.find('.show_comments').click()
end

Then /^I should see the codemark's comments$/ do
  page.should have_content(@comment1.text)
  page.should have_content(@comment2.text)
end

When /^I click on the notepad$/ do
  page.driver.browser.execute_script("$('.actions').css('display', 'inline')")
  page.find('.show_note').click()
end

When /^I go to the "([^"]*)" topic page$/ do |topic_title|
  visit topic_path(@topic)
end

When /^I go to my dashboard$/ do
  visit '/'
end

When /^I go to the public page$/ do
  visit '/public'
end

When /^I go to his page$/ do
  visit "/#{@user.nickname}"
end

When /^I go to that topic page$/ do
  visit topic_path(@topic)
end

Then /^I should see my codemark's note$/ do
  page.should have_content(@codemark.note)
end

Then /^I should not see the codemark's note$/ do
  page.should_not have_content(@codemark.note)
end

Then /^I should see his codemark$/ do
  page.should have_content(@codemark.title)
end

Then /^I should see a nav with my name$/ do
  within('.sidebar') do
    page.should have_content(@current_user.nickname)
  end
end

Then /^I should see a nav with his name$/ do
  within('.sidebar') do
    page.should have_content(@user.nickname)
  end
end

Then /^I should see (\d+) codemarks$/ do |num|
  page.should have_selector('.codemark', :count => num.to_i)
end

Then /^I should see a link, "([^"]*)"$/ do |link_text|
  page.should have_link(link_text)
end

Then /^I should see that codemark first$/ do
  within('.codemark:first-child') do
    page.should have_content(@codemark.title)
  end
end
