require 'spec_helper'

def url_encode_text text
  URI.escape(text, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
end

describe "Bookmarklet" do
end
