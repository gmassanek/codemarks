class CodemarksController < ApplicationController
  require 'tagger'
  require 'smart_link'
  include OOPs

  def build_link
    link = Link.find_by_url(params[:url])
    unless link
      puts "creating new link"
      link = Link.new url: params[:url] 
      puts link.inspect
      link = SmartLink.new(link).better_link
    end
    @codemark = Codemark.new(link: link)
    @codemark.topics = Tagger.get_tags_for_link link

    respond_to do |format|
      format.js
    end

  end
end
