class PresentCodemarks
  extend ActionView::Helpers::DateHelper

  def self.for(codemarks)
    codemarks.map {|codemark| present(codemark) }
  end

  def self.present(codemark)
    {
      :id => codemark.id,
      :title => {
        content: codemark.title,
        href: codemark_path(codemark.id)
      },
      :save_date => "about #{time_ago(codemark.created_at)} ago",
      :author => present_author(codemark.user),
      :show_comments => "Comments (#{codemark.comments.size})",
      :twitter_share => {
        :href => 'http://twitter.com/share',
        :'data-tweet-text' => tweet_link(codemark),
        :content => 'Tweet'
      },
      :corner => codemark.user == current_user(codemark) ? {:class => 'delete', :content => ''} : nil,
      :mine => codemark.user == current_user(codemark),
      :comments => present_comments(codemark.comments),
      :topics => present_topics(codemark.topics),
      :resource => present_resource(codemark.resource)
    }
  end

  def self.present_resource(resource)
    return unless resource # should never happen!
    {
      :host => resource.host
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
    author = codemark.user.nickname
    tags = codemark_short_tag_list(codemark)
    sign_off = "via @#{author} @codemarks"
    message_length = tags.size + sign_off.size + 40
    title_length = 140 - message_length
    title = codemark.title || codemark.link_record.title
    if title.length > title_length
      title = title[0, title_length] + '...'
    end

    text = %!#{title} - #{codemark.url} #{tags} #{sign_off}!
    #url_encode_text(text)
    text
  end
end
