class ResourcesController < ApplicationController
  def click
    resource = params[:resource_type].classify.constantize.find(params[:id])
    Click.create(:resource => resource, :user => current_user)
    render :nothing => true, :status => :ok
  end
end
