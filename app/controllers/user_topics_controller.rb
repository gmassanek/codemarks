class UserTopicsController < ApplicationController

  def create
    @topic = Topic.find params[:id]
    UserTopic.create(:user_id => current_user_id, :topic => @topic)
    respond_to do |format|
      format.js
    end
  end

end
