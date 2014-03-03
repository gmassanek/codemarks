class Filemark < Resource
  hstore_attr :attachment, :attachment_file_name, :attachment_file_size, :attachment_content_type, :attachment_updated_at

  has_attached_file :attachment,
    :storage => :s3,
    :s3_credentials => Proc.new{|a| a.instance.s3_credentials }

  do_not_validate_attachment_file_type :attachment
  validate :attachment_size

  def attachment_size
    if attachment_file_size && attachment_file_size.to_i > 2.megabytes
      @errors.add(:attachment, "must be less than 2MB")
    end
  end

  def s3_credentials
    { 
      access_key_id: 'AKIAJCMCZ4JDCPNNUE7Q',
      secret_access_key: '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',
      bucket: 'codemarks_user_uploads'
    }
  end

  def kilabytes_in_words
    "#{(attachment_file_size.to_i / 1.kilobyte)}kb"
  end
end
