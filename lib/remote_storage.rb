require 'aws/s3'

class RemoteStorage
  def self.upload_link_snapshot(snapshot, id)
    o = s3.buckets['link_snapshots'].objects[id].write(snapshot, :acl => :public_read)
    o.public_url.to_s
  end

  def self.s3
    AWS.config({ access_key_id: 'AKIAJCMCZ4JDCPNNUE7Q', secret_access_key: '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' })
    AWS::S3.new
  end
end
