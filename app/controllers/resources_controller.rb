class ResourcesController < ApplicationController
  def click
    resource = params[:resource_type].classify.constantize.find(params[:id])
    Click.create(:resource => resource, :user => current_user)
    Global.track(:user_id => current_user.try(:slug) || 'logged-out', :event => 'codemark_visit', :properties => { :resource_id => resource.id })
    render :nothing => true, :status => :ok
  end
end
