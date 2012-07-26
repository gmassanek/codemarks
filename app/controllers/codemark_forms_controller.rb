class CodemarkFormsController < ApplicationController

  layout 'codemarklet'

  def text
    @codemark = Codemark.new
    @saver = load_user(params[:saver])
  end

  private

  def load_user(user_id)
    User.find(user_id) if user_id
  end
end
