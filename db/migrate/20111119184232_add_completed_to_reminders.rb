class AddCompletedToReminders < ActiveRecord::Migration
  def change
    add_column :reminders, :completed, :boolean, :default => false
  end
end
