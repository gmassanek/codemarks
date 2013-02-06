class TweetFactory
  TWEET_LENGTH = 140
  SHORTENED_URL_LENGTH = 20

  def self.codemark_of_the_day(codemark)
    self.new(codemark, 'Codemark of the Day!').tweet
  end

  def initialize(codemark, tagline = nil)
    @tagline = tagline
    @codemark = codemark
  end

  def tweet
    @main_text = "#{@tagline} #{@codemark.title}"

    @url = bitly.shorten(@codemark.resource.url).short_url

    while(there_is_room_for_topics?)
      topics_being_tweeted << topics.pop
    end

    tweet_text.sub('  ', ' ')
  end

  private

  def there_is_room_for_topics?
    return false unless topics.present?

    new_length = current_length + topics.last.length + 2
    new_length < TWEET_LENGTH
  end

  def tweet_text
    "#{@main_text} #{@url} #{topic_text} #{via}"
  end

  def current_length
    tweet_text.sub(@url, 'a' * SHORTENED_URL_LENGTH).length
  end

  def topic_text
    topics_being_tweeted.map { |topic| "##{topic}" }.join(' ')
  end

  def topics_being_tweeted
    @topics_being_tweeted ||= []
  end

  def topics
    @topics ||= @codemark.topics.map(&:slug).sort_by(&:length).reverse
  end

  def via
    return @via if @via
    twitter_auth = @codemark.user.authentication_by_provider(:twitter)
    if twitter_auth
      @via = "via @#{twitter_auth.nickname}"
    else
      @via = "via #{@codemark.user.nickname}"
    end
  end

  def bitly
    @bitly ||= Bitly.new('gmassanek', ENV['CODEMARK_BITLY_KEY'])
  end
end
