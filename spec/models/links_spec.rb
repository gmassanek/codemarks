require 'spec_helper'

describe Link do
  let(:valid_url) { "http://www.example.com" }

  required_attributes = [:url, :site_content, :host, :title]
  required_attributes.each do |attr|
    it "requires a #{attr}" do
      link = Fabricate.build(:link, attr => nil)
      link.should_not be_valid
    end
  end

end

#it "gets all links for a list of codemarks" do
#  codemark1 = Fabricate(:codemark)
#  codemark2 = Fabricate(:codemark)
#  Link.for([codemark1, codemark2]).should == [codemark1.link, codemark2.link]
#end
#
#    describe "topics" do
#      it "are associated through codemarks" do
#        github = Fabricate(:topic, title: "Github")
#        codemark = Fabricate(:codemark, topics: [github])
#        codemark.link.topics.should == [github]
#      end
#    end
#  end
#end
