require 'fast_helper'

describe ListenerParamsParser do
  context "email" do
    it "extracts a url from an email body" do
      ListenerParamsParser.extract_urls_from_body("hey there http://www.example.com").should == ["http://www.example.com"]
    end

    it "extracts multiple urls from an email body" do
      ListenerParamsParser.extract_urls_from_body("http://www.google.com hey there http://www.example.com").should == ["http://www.google.com", "http://www.example.com"]
    end

    it "doesn't pick up junk from sendgrid" do
      body = "\n\nBegin forwarded message:\n\n> From: Dave Hoover <dhh@groupon.com>\n> Subject: coderwall\n> Date: March 10, 2012 5:06:52 PM CST\n> To: development@groupon.com\n> \n> If you in any way active on Github, it would rock if you'd hook into coderwall:\n> http://coderwall.com/i/4f271951973bf00004000646/bW1aF0tCM%2Bw\n> \n> I think we can do better than 26th place: http://coderwall.com/leaderboard\n\n"
      ListenerParamsParser.extract_urls_from_body(body).should == ["http://coderwall.com/i/4f271951973bf00004000646/bW1aF0tCM%2Bw", "http://coderwall.com/leaderboard"]
    end
  end

  #let(:params) { {:from => "<Test User> test@example.com" } }

  #it "searches users by email" do
  #  User.should_receive(:find_by_email).with("test@example.com")
  #  IncomingEmailParser.parse params
  #end

  #it "extracts emails from a string" do
  #  IncomingEmailParser.extract_email(params[:from]).should == "test@example.com"
  #  IncomingEmailParser.extract_email("hey there test@example.com").should == "test@example.com"
  #  IncomingEmailParser.extract_email("there test@example.com it works").should == "test@example.com"
  #end

  #it "stores a link if the user exists (but only adds a codemark once)" do
  #  user = Fabricate(:user, email: "test@example.com")
  #  google = Fabricate(:topic, title: "google")
  #  params[:text] = "http://www.google.com /n My Signature"
  #  lambda {
  #    IncomingEmailParser.parse(params)
  #  }.should change(Codemark, :count).by(1)

  #  lambda {
  #    IncomingEmailParser.parse(params)
  #  }.should change(Codemark, :count).by(0)
  #end

  #context "pulls out urls" do
  #  it "for an easy link" do
  #    body = "http://www.google.com /n My Signature"
  #    IncomingEmailParser.extract_urls_into_array(body).length.should == 1
  #    IncomingEmailParser.extract_urls_into_array(body).first.should == "http://www.google.com"
  #  end

  #  it "for a tough link" do
  #    body = "http://www.ericsink.com/entries/vv_fast_import.html /n My Signature"
  #    IncomingEmailParser.extract_urls_into_array(body).length.should == 1
  #    IncomingEmailParser.extract_urls_into_array(body).first.should == "http://www.ericsink.com/entries/vv_fast_import.html"
  #  end

  #  it "for multiple links" do
  #    body = "here is a link to http://www.google.com and http://www.yahoo.com"
  #    IncomingEmailParser.extract_urls_into_array(body).should == ["http://www.google.com", "http://www.yahoo.com"]
  #  end

  #  it "saves multiple links" do
  #    user = Fabricate(:user, email: "test@example.com")
  #    google = Fabricate(:topic, title: "google")
  #    yahoo = Fabricate(:topic, title: "yahoo")
  #    params[:text] = "here is a link to http://www.google.com and http://www.yahoo.com"
  #    lambda {
  #      IncomingEmailParser.parse(params)
  #    }.should change(Codemark, :count).by(2)
  #  end
  #end
end

def email_params from_email, from_name, to, subject, body
  {
    "headers"=>"Received: by 127.0.0.1 with SMTP id muIOsJZF2V Sat, 17 Dec 2011 14:08:29 -0600 (CST)
    Received: from mail-gx0-f179.google.com (mail-gx0-f179.google.com [209.85.161.179]) by mx3.sendgrid.net (Postfix) with ESMTPS id 1431114ECA46 for <#{ from_email }>; Sat, 17 Dec 2011 14:08:29 -0600 (CST)
    Received: by ggnv5 with SMTP id v5so4547472ggn.24 for <#{ to }>; Sat, 17 Dec 2011 12:08:28 -0800 (PST)
    DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=gamma; h=from:content-type:content-transfer-encoding:subject:date:message-id :to:mime-version:x-mailer; bh=On0k0lEBsumdK+lkX7U3ZhN6sF/9FOnD3vWMWRNppOY=; b=INFmQ6BDUUW9JnahEqV6AqL4QPnafwlMaNkk0LD5xNiLP/8tmlqs8Cw4+xDl3JXfF0 ekr9lIfA3KCWtmCIxZl+lOOKViL3S4dfBCsyZz0rd56zI2OAvLHnZ2beX11bNK2PSyYa 3tAtgWt7y7kwGYXXuq3V7V5huYQr3RdYSeRCc=
    Received: by 10.100.86.11 with SMTP id j11mr6007277anb.23.1324152508698; Sat, 17 Dec 2011 12:08:28 -0800 (PST)
    Received: from [10.60.204.30] ([74.201.7.112]) by mx.google.com with ESMTPS id i32sm31573521anm.6.2011.12.17.12.08.28 (version=TLSv1/SSLv3 cipher=OTHER); Sat, 17 Dec 2011 12:08:28 -0800 (PST)
    From: #{from_name} <#{ from_email }>
    Content-Type: text/plain; charset=us-ascii
    Content-Transfer-Encoding: 7bit
    Subject: #{ subject }
    Date: Sat, 17 Dec 2011 14:08:29 -0600
    Message-Id: <01DDBEFD-7FDA-429C-B6DA-B061611F6275@gmail.com>
    To: #{ to }
    Mime-Version: 1.0 (Apple Message framework v1251.1)
    X-Mailer: Apple Mail (2.1251.1)",
    "attachments"=>"0",
    "dkim"=>"{@gmail.com : pass}",
    "subject"=>"#{ subject }",
    "to"=>"#{ to }",
    "from"=>"#{from_name} <#{ from_email }>",
    "text"=>"#{ body }",
    "envelope"=>"{\"to\":[\"#{ to }\"],\"from\":\"#{ from_email }\"}",
    "charsets"=>"{\"to\":\"UTF-8\",\"subject\":\"UTF-8\",\"from\":\"UTF-8\",\"text\":\"us-ascii\"}",
    "SPF"=>"pass"
  }
end
