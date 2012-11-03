require 'grabzitclient'

class SiteSnapshot
  WIDTH = '705'
  HEIGHT = '642'
  def self.save_picture(url, filepath)
    #grabzItClient = GrabzItClient.new(ENV['GRABZIT_KEY'], ENV['GRABZIT_SECRET'])
    grabzItClient = GrabzItClient.new('Z21hc3NhbmVrQGdtYWlsLmNvbQ==', 'GXQ/VT8Efi0/Pz8hPyk/P2YCOz9HGD84P3wVPw0/M1Q=')
    grabzItClient.save_picture(url, filepath, WIDTH, HEIGHT)
  end
end
