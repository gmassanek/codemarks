module ApplicationHelper

  def sign_in_path(provider)
    "auth/#{provider.to_s}"
  end

end
