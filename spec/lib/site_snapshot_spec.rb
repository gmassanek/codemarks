require 'site_snapshot'

describe SiteSnapshot do
  describe '.save_picture' do
    it 'calls save_picture on a new grabzit client instance' do
      url, filepath = 'http://www.google.com', '/tmp/img1.jpeg'
      client = mock
      GrabzItClient.should_receive(:new).and_return(client)
      client.should_receive(:save_picture).with(url, filepath)
      SiteSnapshot.save_picture(url, filepath)
    end
  end
end
