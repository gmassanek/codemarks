class LinksController < ApplicationController
  def click
    @link = LinkRecord.find(params[:id])
    Click.create(:link_record => @link, :user => current_user)
    render :nothing => true, :status => :ok
  end
end
