class UserCodemarkAuthorizer
  def initialize(user, codemark, action = :edit)
    @user = user
    @codemark = codemark
    @action = action.to_sym
  end

  def authorized?
    if @action == :view
      viewable?
    elsif @action == :edit
      viewable? && editable?
    else
      false
    end
  end

  private
  def viewable?
    !@codemark.group || (@user && @user.groups.include?(@codemark.group))
  end

  def editable?
    mine? || in_one_of_my_groups?
  end

  def mine?
    @user && @user == @codemark.user
  end

  def in_one_of_my_groups?
    @codemark.group && @user && @user.groups.include?(@codemark.group)
  end
end
