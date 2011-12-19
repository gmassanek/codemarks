class CodemarksController < ApplicationController
  require 'tagger'
  require 'smart_link'
  require 'codemarker'
  include OOPs

  def build_link
    link = Link.find_by_url(params[:url])
    if link
      @codemark = Codemark.new(link: link)
      @codemark.topics = link.topics
    else
      link = Link.new url: params[:url] 
      link = SmartLink.new(link).better_link
      @codemark = Codemark.new(link: link)
      @codemark.topics = Tagger.get_tags_for_link link if link.response
    end

    respond_to do |format|
      format.js
    end
  end

  def create
    @codemark = Codemark.new
    link_id = params[:codemark][:link][:id]
    if link_id.present?
      @codemark.link = Link.find params[:codemark][:link][:id]
    else
      @codemark.link = Link.new params[:codemark][:link]
    end
    @codemark.user = current_user
    @codemark.topics = Topic.find params[:topic_ids].keys.reject! { |topic| topic.match(/[^0-9]/) }

    new_topics = params[:topic_ids].keys
    new_topics.reject! { |topic| !topic.match(/[^0-9]/) }
    new_topics.each do |title|
      @codemark.topics << Topic.new(title: title, user: current_user)
    end

    if Codemarker.mark! @codemark
      redirect_to dashboard_path, notice: "Codemark created"
    else
      redirect_to dashboard_path, notice: "Sorry, something went wrong"
    end
  end
end
