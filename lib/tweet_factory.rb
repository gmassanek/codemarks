class TweetFactory
  TWEET_LENGTH = 140
  SHORTENED_URL_LENGTH = 20

  def self.codemark_of_the_day(codemark)
    self.new(codemark, :hashtags => ['cmoftheday']).tweet
  end

  def initialize(codemark, options = {})
    @tagline = options[:tagline]
    @hashtags = options[:hashtags].map { |t| sanitize_tag(t) } || []
    @codemark = codemark
  end

  def tweet
    while tag_fits?(tag = topics.pop)
      @hashtags << tag
    end

    tweet_text
  end

  private

  def tag_fits?(tag)
    return false unless tag

    current_length + tag.length + 2 <= TWEET_LENGTH
  end

  def url
    @url ||= bitly.shorten(@codemark.resource.url).short_url
  end

  def tweet_text
    parts = []
    parts << @tagline if @tagline.present?
    parts << @codemark.title if @codemark.title.present?
    parts << url
    parts << via
    parts += @hashtags.reverse
    parts.join(' ')
  end

  def current_length
    tweet_text.gsub(url, 'a' * SHORTENED_URL_LENGTH).length
  end

  def topics
    @topics ||= @codemark.topics.map(&:slug).map { |t| sanitize_tag(t) }.sort_by(&:length).reverse
  end

  def sanitize_tag(tag)
    tag = tag.gsub("-", "_").gsub(" ", "_")
    "##{tag}" unless tag[0] == '#'
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
