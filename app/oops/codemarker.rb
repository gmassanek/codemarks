module OOPs
  class Codemarker
    include Exceptions
    class << self
      def mark!(codemark)
        raise LinkRequiredError if codemark.link.nil?
        raise InvalidLinkError unless codemark.link.valid?
        raise UserRequiredError if codemark.user.nil?
        #raise TopicsRequiredError if topics.nil? || topics.empty?

        link = codemark.link
        if link.url[-1] == "/"
          link.url = link.url[0..-2]
          codemark.link = link
        end
        user = codemark.user

        existing_link = Link.find_by_url(link.url)
        if existing_link
          link = existing_link
        else
          link.save!
        end
        
        existing_codemark = user.codemark_for(link)
        if existing_codemark
          existing_codemark.topics = codemark.topics
          codemark = existing_codemark
        end

        codemark.save!
        return codemark
      end
    end
  end
end
