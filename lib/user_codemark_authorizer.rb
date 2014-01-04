class UserCodemarkAuthorizer
  def initialize(user, codemark)
    @user = user
    @codemark = codemark
  end

  def authorized?
    !@codemark.group || (@user && @user.groups.include?(@codemark.group))
  end
end
