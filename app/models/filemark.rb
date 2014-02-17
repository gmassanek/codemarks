class Filemark < Resource
  hstore_attr :attachment, :attachment_file_name, :attachment_file_size, :attachment_content_type, :attachment_updated_at

  has_attached_file :attachment,
    :storage => :s3,
    :s3_credentials => Proc.new{|a| a.instance.s3_credentials }

  validates_attachment_content_type :attachment, :content_type => %w(image/jpeg image/jpg image/png text/html)

  def s3_credentials
    { access_key_id: 'AKIAJCMCZ4JDCPNNUE7Q', secret_access_key: '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', bucket: 'codemarks_user_uploads' }
  end
end
