require 'codemarker'
require 'tagger'
require 'smart_link'

module OOPs
  class IncomingEmailParser 
    class << self
      def parse params
        email = extract_email(params[:from])
        user = User.find_by_email(email) if email.present?
        if user
          urls = extract_urls_into_array params[:text]
          urls.each do |url|
            puts "hello"
            save_codemark(user, url)
            puts url.inspect
          end
        end
      end

      def extract_email(txt)
        reg = /[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}/i
        txt.scan(reg).first
      end

      def extract_urls_into_array(txt)
        reg = URI::regexp
        
        urls = txt.scan(reg).uniq.collect do |uri|
          "#{uri[0]}://#{uri[3]}"
        end
      end

      def save_codemark(user, url)
        link = Link.new(url: url)
        link = OOPs::SmartLink.new(link).better_link
        topics = OOPs::Tagger.get_tags_for_link link
        codemark = Codemark.new
        codemark.user = user
        codemark.link = link
        puts user.valid?
        puts "BOOM"
        puts codemark.inspect
        puts topics.inspect

        OOPs::Codemarker.mark!(codemark)
      end
    end
  end
end
