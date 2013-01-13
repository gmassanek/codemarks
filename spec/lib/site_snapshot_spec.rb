require 'site_snapshot'

describe SiteSnapshot do
  describe '.create' do
    before do
      @client = mock
      SiteSnapshot.stub(:grabzItClient => @client)
    end

    it 'calls take_picture and waits for it to be done' do
      url = 'http://www.google.com'
      @client.should_receive(:take_picture).with(url, nil, nil, SiteSnapshot::WIDTH, SiteSnapshot::HEIGHT).and_return('ABC123')
      @client.should_receive(:get_status).with('ABC123').and_return(mock(:processing => false, :message => nil))
      SiteSnapshot.create(url).should == 'ABC123'
    end
  end
end
