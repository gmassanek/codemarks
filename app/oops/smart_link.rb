module OOPs
  include Exceptions

  class SmartLink
    require 'open-uri'
    require 'nokogiri'

    attr_accessor :link
    
    def initialize(link)
      raise LinkRequiredError if link.nil?

      link.valid?
      if link.errors.include? :url
        raise InvalidLinkError
      end

      self.link = link
    end
    
    def better_link
      b_link = link
      response = html_response b_link.url
      if response
        b_link.response = response
        b_link.title = response.title
        b_link.host = URI.parse(b_link.url).host
      end
      b_link
    end

    private

    def html_response url
      Nokogiri::HTML(open(url))
      rescue
        return nil
    end

  end

end
