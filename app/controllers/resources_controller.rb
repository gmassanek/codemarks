class ResourcesController < ApplicationController
  def click
    resource = params[:resource_type].classify.constantize.find(params[:id])
    Click.create(:resource => resource, :user => current_user)
    data = {
      :resource_id => resource.id
    }
    Global.track(:user_id => current_user.nickname, :event => 'codemark_visit', :properties => data)
    render :nothing => true, :status => :ok
  end
end
