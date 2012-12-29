class SnapLinkJob < Struct.new(:link)
  def perform
    return if ENV['RAILS_ENV']=='test'
    return link.snapshot_url

    SiteSnapshot.save_snapshot_for(link)
  end
end
