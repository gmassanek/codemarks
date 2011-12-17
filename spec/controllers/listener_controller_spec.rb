require 'spec_helper'

describe ListenerController do
  before do
    @method = :post
    @action = :sendgrid
    @params = {format: "json"}
    send @method, @action, @params
  end

  it "listens for sendgrid emails" do
    response.response_code.should == 200
  end
end
