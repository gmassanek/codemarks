require 'spec_helper'

describe Link do
  describe "URLs" do
    it "gets all links for a list of codemarks" do
      codemark1 = Fabricate(:codemark)
      codemark2 = Fabricate(:codemark)
      Link.for([codemark1, codemark2]).should == [codemark1.link, codemark2.link]
    end

    describe "validations" do
      let (:link) { Fabricate.build(:link) }

      it "are required" do
        link.url = nil
        link.should_not be_valid
      end

      ["http://www.twitter.com", "https://twitter"].each do |url|
        it "accepts #{url}" do
          link.url = url
          link.should be_valid
        end
      end

      ["twitter.com", "twitter", "www.twitter.com"].each do |url|
        it "rejects #{url}" do
          link.url = url
          link.should_not be_valid
        end
      end
    end

    describe "topics" do
      it "are associated through codemarks" do
        github = Fabricate(:topic, title: "Github")
        codemark = Fabricate(:codemark, topics: [github])
        codemark.link.topics.should == [github]
      end
    end
  end
end
