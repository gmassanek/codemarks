require 'spec_helper'

describe Link do
  let(:valid_url) { "http://www.example.com" }

  it "saves to the database" do
    link = Link.new
    link.save!
  end
end
