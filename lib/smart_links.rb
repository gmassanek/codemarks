module SmartLinks

  class MyCurl
    require 'net/http'

    def self.get_title_content(url)
      response = get_body(url)
      title_tag = response.scan(/<title>(.*?)<\/title>/)[0]
      puts title_tag.inspect
      if title_tag.present?
        return title_tag[0]
      else
        return url
      end
    end

    private
    def self.get_body(url)
      Net::HTTP.get(URI(url))
    end
  end

end
