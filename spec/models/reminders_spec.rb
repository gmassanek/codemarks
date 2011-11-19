require 'spec_helper'

describe Reminder do
  it "requires a link" do
    reminder = Fabricate(:reminder)
    reminder.link = nil
    reminder.should_not be_valid
  end

  it "requires a user" do
    reminder = Fabricate(:reminder)
    reminder.user = nil
    reminder.should_not be_valid
  end
end
