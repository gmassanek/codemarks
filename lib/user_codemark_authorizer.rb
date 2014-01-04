class UserCodemarkAuthorizer
  def initialize(user, codemark)
    @user = user
    @codemark = codemark
  end

  def authorized?
    if @codemark.group
      if @user
        @user.groups.include?(@codemark.group)
      else
        false
      end
    else
      true
    end
  end
end
