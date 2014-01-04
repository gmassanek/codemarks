class UserCodemarkAuthorizer
  def initialize(user, codemark)
    @user = user
    @codemark = codemark
  end

  def authorized?
    if @user
      @codemark.group && @user.groups.include?(@codemark.group)
    else
      !@codemark.group
    end
  end
end
