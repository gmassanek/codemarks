class ResourcesController < ApplicationController
  def click
    resource = params[:resource_type].classify.constantize.find(params[:id])
    Click.create(:resource => resource, :user => current_user)
    Global.track(:user_id => current_user.try(:slug) || 'logged-out', :event => 'codemark_visit', :properties => { :resource_id => resource.id })
    render :nothing => true, :status => :ok
  end

  def create
    p params
    case params['type']
    when 'Filemark'
      resource = Filemark.new(:attachment => params['attachment'])
    when 'ImageFile'
      resource = ImageFile.new(:attachment => params['attachment'])
    end

    if resource.save
      render :json => PresentCodemarks.present_resource(resource)
    else
      render :json => resource.errors.full_messages, :status => 402
    end
  end
end
