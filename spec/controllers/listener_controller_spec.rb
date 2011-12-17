require 'spec_helper'
require 'incoming_email_parser'

def email_params from_email, from_name, to, subject, body
  {"headers"=>"Received: by 127.0.0.1 with SMTP id muIOsJZF2V Sat, 17 Dec 2011 14:08:29 -0600 (CST)\nReceived: from mail-gx0-f179.google.com (mail-gx0-f179.google.com [209.85.161.179]) by mx3.sendgrid.net (Postfix) with ESMTPS id 1431114ECA46 for <#{ from_email }>; Sat, 17 Dec 2011 14:08:29 -0600 (CST)\nReceived: by ggnv5 with SMTP id v5so4547472ggn.24 for <#{ to }>; Sat, 17 Dec 2011 12:08:28 -0800 (PST)\nDKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=gamma; h=from:content-type:content-transfer-encoding:subject:date:message-id :to:mime-version:x-mailer; bh=On0k0lEBsumdK+lkX7U3ZhN6sF/9FOnD3vWMWRNppOY=; b=INFmQ6BDUUW9JnahEqV6AqL4QPnafwlMaNkk0LD5xNiLP/8tmlqs8Cw4+xDl3JXfF0 ekr9lIfA3KCWtmCIxZl+lOOKViL3S4dfBCsyZz0rd56zI2OAvLHnZ2beX11bNK2PSyYa 3tAtgWt7y7kwGYXXuq3V7V5huYQr3RdYSeRCc=\nReceived: by 10.100.86.11 with SMTP id j11mr6007277anb.23.1324152508698; Sat, 17 Dec 2011 12:08:28 -0800 (PST)\nReceived: from [10.60.204.30] ([74.201.7.112]) by mx.google.com with ESMTPS id i32sm31573521anm.6.2011.12.17.12.08.28 (version=TLSv1/SSLv3 cipher=OTHER); Sat, 17 Dec 2011 12:08:28 -0800 (PST)\nFrom: #{from_name} <#{ from_email }>\nContent-Type: text/plain; charset=us-ascii\nContent-Transfer-Encoding: 7bit\nSubject: #{ subject }\nDate: Sat, 17 Dec 2011 14:08:29 -0600\nMessage-Id: <01DDBEFD-7FDA-429C-B6DA-B061611F6275@gmail.com>\nTo: #{ to }\nMime-Version: 1.0 (Apple Message framework v1251.1)\nX-Mailer: Apple Mail (2.1251.1)\n", "attachments"=>"0", "dkim"=>"{@gmail.com : pass}", "subject"=>"#{ subject }", "to"=>"#{ to }", "from"=>"#{from_name} <#{ from_email }>", "text"=>"#{ body }\n", "envelope"=>"{\"to\":[\"#{ to }\"],\"from\":\"#{ from_email }\"}", "charsets"=>"{\"to\":\"UTF-8\",\"subject\":\"UTF-8\",\"from\":\"UTF-8\",\"text\":\"us-ascii\"}", "SPF"=>"pass"}
end

describe ListenerController do
  before do
    @method = :post
    @action = :sendgrid
    @user = Fabricate(:user, email: "the_man@gmail.com")
    @params = email_params(@user.email, "Frank", "mark@codemarks.org", "Here is a subject", "http://www.google.com")
    @params[:format] = "json"
  end

  it "listens for sendgrid emails" do
    IncomingEmailParser.should_receive(:parse)
    send @method, @action, @params
    controller.params[:from].should include(@user.email)
    response.response_code.should == 200
  end
end
