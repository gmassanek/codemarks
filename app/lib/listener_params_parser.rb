class ListenerParamsParser
  class << self
    def prepare_bookmarklet(params)
      { :url => params[:l] }
    end

    def extract_urls_from_body(body)
      reg = URI::regexp
      
      urls = body.scan(reg).uniq.collect do |uri|
        "#{uri[0]}://#{uri[3]}#{uri[6]}"
      end
    end
  end
  #class << self
  #  def save_bookmarklet user, url
  #    save_codemark(user, url) if user
  #  end

  #  def parse params
  #    email = extract_email(params[:from])
  #    user = User.find_by_email(email) if email.present?
  #    if user
  #      urls = extract_urls_into_array params[:text]
  #      urls.each do |url|
  #        save_codemark(user, url)
  #      end
  #    end
  #  end

  #  def extract_email(txt)
  #    reg = /[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}/i
  #    txt.scan(reg).first
  #  end

  #  def extract_urls_into_array(txt)
  #    reg = URI::regexp
  #    
  #    urls = txt.scan(reg).uniq.collect do |uri|
  #      "#{uri[0]}://#{uri[3]}#{uri[6]}"
  #    end
  #  end

  #  def save_codemark(user, url)
  #    link = Link.new(url: url)
  #    link = OOPs::SmartLink.new(link).better_link
  #    topics = OOPs::Tagger.get_tags_for_link link
  #    codemark = Codemark.new
  #    codemark.user = user
  #    codemark.link = link
  #    codemark.topics = topics

  #    OOPs::Codemarker.mark!(codemark)
  #  end
  #end
end
