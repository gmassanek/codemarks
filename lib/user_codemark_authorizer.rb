class UserCodemarkAuthorizer
  def initialize(user, codemark)
    @user = user
    @codemark = codemark
  end

  def authorized?
    if @user
      (@user.group_ids + [Group::DEFAULT.id]).include?(@codemark.group_id)
    else
      [Group::DEFAULT.id].include?(@codemark.group_id)
    end
  end
end
