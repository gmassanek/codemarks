module OOPs
  class Authenticator
    class << self
      def find_or_create_user_from_auth_hash provider, auth_hash
        raise AuthHashRequiredError if auth_hash.nil? || auth_hash.empty?
        raise AuthProviderRequiredError if provider.nil? || provider.empty?

        uid = auth_hash[:uid]
        puts uid.inspect

        existing_auth = find_auth(provider, uid)
        return existing_auth.user if existing_auth

        user = User.new
        user.authentications.build(provider: provider, uid: uid)
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
          auth.update_attributes(uid: auth_hash[:uid])
        else
          user.authentications.create!(uid: auth_hash[:uid], provider: provider)
        end
      end
    end
  end
end
