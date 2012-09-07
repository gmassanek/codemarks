class PresentCodemarks
  extend ActionView::Helpers::DateHelper

  def self.for(codemarks, current_user = nil)
    response = {
      codemarks: codemarks.select {|cm| cm.resource }.map {|codemark| present(codemark, current_user) }
    }
    response[:pagination] = present_pagination(codemarks)
    response
  end

  def self.present_pagination(codemarks)
    {
      :total_pages => codemarks.num_pages
    }
  end

  def self.present(codemark, current_user = nil)
    {
      :id => codemark.id,
      :save_date => "about #{time_ago(codemark.created_at)} ago",
      :author => present_author(codemark.user),
      :show_comments => "Comments (#{codemark.comments.size})",
      :twitter_share => {
        :href => 'http://twitter.com/share',
        :'data-tweet-text' => tweet_link(codemark),
        :content => 'Tweet'
      },
      :mine => mine?(codemark, current_user),
      :corner => mine?(codemark, current_user) ? {:class => 'delete', :content => ''} : nil,
      :actions => actions(mine?(codemark, current_user)),
      :comments => present_comments(codemark.comments),
      :topics => present_topics(codemark.topics),
      :resource => present_resource(codemark)
    }
  end

  def self.present_resource(codemark)
    resource = codemark.resource
    return unless resource # should never happen!
    case resource.resource_type 
    when 'text'
      resource_data = present_text_record(codemark, resource)
    when 'link'
      resource_data = present_link_record(codemark, resource)
    end
    {
      :id => resource.id,
      :type => resource.resource_type,
    }.merge!(resource_data)
  end

  def self.present_link_record(codemark, resource)
    {
      :host => resource.host,
      :url => resource.url,
      :title => {:content=>codemark.title, :href=>resource.url}
    }
  end

  def self.present_text_record(codemark, resource)
    {
      :text => resource.text,
      :title => codemark.title
    }
  end

  def self.present_topics(topics)
    return unless topics
    topics.map {|topic| present_topic(topic) }
  end

  def self.present_topic(topic)
    {
      :id => topic.id,
      :topic_title => {
        :content => topic.title,
        :href => topic_path(topic.id)
      }
    }
  end

  def self.present_author(author)
    return unless author
    {
      :name => author.nickname,
      :avatar => {
        :content => '',
        :src => author.get(:image)
      }
    }
  end

  def self.present_comments(comments)
    return unless comments
    comments.map {|comment| present_comment(comment) }
  end

  def self.present_comment(comment)
    {
      :author => present_author(comment.author)
    }
  end

  def self.tweet_link(codemark)
    tweet_text(codemark)
  end

  def self.time_ago(time)
    time_ago_in_words(time)
  end

  def self.codemark_path(id)
    Rails.application.routes.url_helpers.codemark_path(id)
  end

  def self.topic_path(id)
    Rails.application.routes.url_helpers.topic_path(id)
  end

  def self.codemark_short_tag_list(codemark)
    tags = codemark.topics.first(3)
    if tags
      tag_texts = tags.collect do |tag|
        "##{tag.slug}"
      end
      tag_texts.join(" ")
    else
      ""
    end
  end

  def self.tweet_text(codemark)
    return unless codemark.resource # should never happen!
    return unless codemark.user
    author = codemark.user.nickname
    tags = codemark_short_tag_list(codemark)
    sign_off = "via @#{author} @codemarks"
    message_length = tags.size + sign_off.size + 40
    title_length = 140 - message_length
    title = codemark.title
    if title && title.length > title_length
      title = title[0, title_length] + '...'
    end

    url = codemark.url if codemark.resource_type == 'LinkRecord'
    text = %!#{title} - #{url} #{tags} #{sign_off}!
    #url_encode_text(text)
    text
  end

  def self.mine?(codemark, current_user)
    codemark.user == current_user
  end

  def self.actions(mine)
    if mine
      { :copy => nil }
    else
      { :edit => nil }
    end
  end
end
