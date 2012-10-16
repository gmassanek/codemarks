class SnapLinkJob < Struct.new(:link)
  def perform
    return if ENV['RAILS_ENV']=='test'
    p "Taking Snapshot for: #{link.url}"

    filepath = "/tmp/snapshot_#{link.id}.jpeg"
    if SiteSnapshot.save_picture(link.url, filepath)
      snapshot = File.new(filepath, 'r').read
      snapshot_url = RemoteStorage.upload_link_snapshot(snapshot, link.id)
      link.update_attributes(:snapshot_url => snapshot_url)
      File.delete(filepath)
    else
      link.update_attributes(:snapshot_url => 'assets/error_loading.png')
    end
  rescue Exception => e
    p 'Failed to take snapshot'
    p e
    puts e.backtrace.first(10).join("\n")
    link.update_attributes(:snapshot_url => 'assets/error_loading.png')
  end
end
