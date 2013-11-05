class Authenticator
  class << self
    def find_or_create_user_from_auth_hash(provider, auth_hash)
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
      Authentication.where(["provider = ? and uid = ?", provider, uid.to_s]).first
    end

    def add_authentication_to_user(user, provider, auth_hash)
      raise UserRequiredError if user.nil?
      raise AuthHashRequiredError if auth_hash.nil? || auth_hash.empty?
      raise AuthProviderRequiredError if provider.nil? || provider.empty?

      if auth = user.authentication_by_provider(provider)
        auth.uid = auth_uid(auth_hash)
        set_info_fields(auth, auth_hash)
        auth.save!
      else
        authentication = user.authentications.build(provider: provider, uid: auth_uid(auth_hash))
        set_info_fields(authentication, auth_hash)
        authentication.save!
      end
    end

    def auth_uid auth_hash
      auth_hash["uid"] ||= auth_hash[:uid]
    end

    def set_info_fields authentication, auth_hash
      info = auth_hash[:info] ||= auth_hash["info"]
      return if info.nil?
      authentication.name = info['name'] || info[:name]
      authentication.email = info['email'] || info[:email]
      authentication.location = info['location'] || info[:location]
      authentication.image = info['image'] || info[:image]
      authentication.description = info['description'] || info[:description]
      authentication.nickname = info['nickname'] || info[:nickname]
    end
  end
end
