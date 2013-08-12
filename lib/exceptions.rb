module Exceptions
  class UserRequiredError < StandardError; end
  class AuthHashRequiredError < StandardError; end
  class AuthProviderRequiredError < StandardError; end
end
