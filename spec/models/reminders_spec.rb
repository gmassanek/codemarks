require 'spec_helper'

describe Reminder do

  let (:reminder) {Fabricate(:reminder)}

  it "requires a link" do
    reminder.link = nil
    reminder.should_not be_valid
  end

  it "requires a user" do
    reminder.user = nil
    reminder.should_not be_valid
  end

  it "closes the reminder if a user clicks on a link that was a reminder" do
    click = Fabricate(:click, :user => reminder.user, :link => reminder.link)
    reminder = Reminder.last
    reminder.should be_completed
  end
end
