class RemindersController < ApplicationController

  def create
    @link = Link.find params[:link_id]
    @user = User.find params[:user_id]
    Reminder.create!(:user => @user, :link => @link)

    respond_to do |format|
      format.js
    end

  end

end
