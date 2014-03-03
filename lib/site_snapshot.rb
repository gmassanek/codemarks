require 'grabzitclient'

class SiteSnapshot
  WIDTH = '705'
  HEIGHT = '642'

  def self.save_snapshot_for(link)
    p "Taking Snapshot for: #{link.url}"

    if snapshot_id = SiteSnapshot.create(link.url)
      snapshot = grabzItClient.get_picture(snapshot_id)
      snapshot_url = RemoteStorage.upload_link_snapshot(snapshot, snapshot_id)
      link.update_attributes(:snapshot_url => snapshot_url, :snapshot_id => snapshot_id)
    else
      link.update_attributes(:snapshot_url => '/assets/error_loading.png')
    end
  rescue Exception => e
    p 'Failed to take snapshot'
    p e
    puts e.backtrace.first(10).join("\n")
    link.update_attributes(:snapshot_url => '/assets/error_loading.png')
  ensure
    Pusher.trigger("codemarks", "snapshot:loaded", { resourceId: link.id })
  end

  def self.create(url)
    snapshot_id = grabzItClient.take_picture(url, nil, nil, WIDTH, HEIGHT)
    status = grabzItClient.get_status(snapshot_id)
    while status.processing do
      sleep(2)
      status = grabzItClient.get_status(snapshot_id)
    end
    snapshot_id unless status.message
  end

  def self.grabzItClient
    GrabzItClient.new(ENV['GRABZIT_KEY'], ENV['GRABZIT_SECRET'])
  end
end
