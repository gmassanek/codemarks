module OOPs
  class Authenticator
    class << self
      def find_or_create_user_from_auth_hash provider, auth_hash
        raise AuthHashRequiredError if auth_hash.nil? || auth_hash.empty?
        raise AuthProviderRequiredError if provider.nil? || provider.empty?
        uid = auth_uid(auth_hash)

        existing_auth = find_auth(provider, uid)
        return existing_auth.user if existing_auth

        user = User.new
        authentication = user.authentications.build(provider: provider, uid: uid)
        set_info_fields(authentication, auth_hash)
        user.save!
        return user
      end

      def find_auth(provider, uid)
        Authentication.find_by_provider_and_uid(provider, uid)
      end

      def add_authentication_to_user(user, provider, auth_hash)
        raise UserRequiredError if user.nil?
        raise AuthHashRequiredError if auth_hash.nil? || auth_hash.empty?
        raise AuthProviderRequiredError if provider.nil? || provider.empty?

        if auth = user.authentication_by_provider(provider)
          auth.update_attributes(uid: auth_uid(auth_hash))
        else
          user.authentications.create!(uid: auth_uid(auth_hash), provider: provider)
        end
      end

      def auth_uid auth_hash
        auth_hash["uid"] ||= auth_hash[:uid]
      end

      def set_info_fields authentication, auth_hash
        info = auth_hash[:info] ||= auth_hash["info"]
        authentication.name = info["name"] ||= info[:name]
        authentication.email = info["email"] ||= info[:email]
        authentication.location = info[:location] ||= info["location"]
        authentication.image = info[:image] ||= info["image"]
        #authentication.url = info[:url] ||= info["url"]
        #authentication.followers_count = info[:folowers_count] ||= info["folowers_count"]
        #authentication.listed_count = info[:listed_count] ||= info["listed_count"]
        authentication.description = info[:description] ||= info["description"]
        authentication.nickname = info[:nickname] ||= info["nickname"]
      end
    end
  end
end
