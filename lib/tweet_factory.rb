class TweetFactory
  TWEET_LENGTH = 140
  SHORTENED_URL_LENGTH = 20

  def self.codemark_of_the_day(codemark)
    self.new(codemark, :hashtags => ['cmoftheday']).tweet
  end

  def initialize(codemark, options = {})
    @tagline = options[:tagline]
    @hashtags = options[:hashtags]
    @codemark = codemark
  end

  def tweet
    @parts = []
    @parts << @tagline if @tagline.present?
    @parts << @codemark.title

    @parts << @url = bitly.shorten(@codemark.resource.url).short_url

    while(there_is_room_for_topics?)
      topics_being_tweeted << topics.pop
    end

    @parts << topic_text
    @parts << via
    tweet_text.sub('  ', ' ')
  end

  private

  def there_is_room_for_topics?
    return false unless topics.present?

    new_length = current_length + topics.last.length + 2
    new_length < TWEET_LENGTH
  end

  def tweet_text
    @parts.join(' ')
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
    user = @codemark.resource_author || @codemark.user
    twitter_auth = user.authentication_by_provider(:twitter)
    if twitter_auth
      @via = "via @#{twitter_auth.nickname}"
    else
      @via = "via #{user.nickname}"
    end
  end

  def bitly
    @bitly ||= Bitly.new('gmassanek', ENV['CODEMARK_BITLY_KEY'])
  end
end
