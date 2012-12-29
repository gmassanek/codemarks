module UserHelper
  def current_user_image
    image_tag(current_user.get(:image)) if current_user.get(:image).present?
  end
end
