class ImageFile < Filemark
  validates_attachment_content_type :attachment, :content_type => %w(image/jpeg image/jpg image/png)
end
