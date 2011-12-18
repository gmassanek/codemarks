module OOPs
  class Authenticator
    class << self
      def find_or_create_user_from_auth_hash provider, auth_hash
        logger.info provider.inspect
        logger.info auth_hash.inspect
        raise AuthHashRequiredError if auth_hash.nil? || auth_hash.empty?
        raise AuthProviderRequiredError if provider.nil? || provider.empty?
        uid = auth_uid(auth_hash)

        existing_auth = find_auth(provider, uid)
        return existing_auth.user if existing_auth

        user = User.new
        authentication = user.authentications.build(provider: provider, uid: uid)
        set_extra_fields(authentication, auth_hash)
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

      def set_extra_fields authentication, auth_hash
        authentication.name = auth_hash["name"] ||= auth_hash[:name]
        authentication.name = auth_hash["name"] ||= auth_hash[:name]
        authentication.profile_image_url = auth_hash[:profile_image_url] ||= auth_hash["profile_image_url"]
        authentication.location = auth_hash[:location] ||= auth_hash["location"]
        authentication.url = auth_hash[:url] ||= auth_hash["url"]
        authentication.followers_count = auth_hash[:folowers_count] ||= auth_hash["folowers_count"]
        authentication.listed_count = auth_hash[:listed_count] ||= auth_hash["listed_count"]
        authentication.description = auth_hash[:description] ||= auth_hash["description"]
        authentication.screen_name = auth_hash[:screen_name] ||= auth_hash["screen_name"]
      end
    end
  end
end
