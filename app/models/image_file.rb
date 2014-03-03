class ImageFile < Filemark
  validates_attachment_content_type :attachment, :content_type => /\Aimage/
end
