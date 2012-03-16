require 'spec_helper'

describe ListenerController do
  describe "#prepare_bookmarklet" do
    let(:valid_url) { "http://www.example.com" }

    it "by passing the incoming URL to Codemark.prepare" do
      Codemark.should_receive(:prepare).with(:link, {:url => valid_url})
      get :prepare_bookmarklet, format: :js, l: valid_url
    end

    it "assigns @user_id from the :l parameter" do
      Codemark.stub(:prepare)
      get :prepare_bookmarklet, format: :js, l: valid_url, id: 234
      assigns[:user_id].should == "234"
    end

    it "assigns @codemark" do
      cm = stub
      Codemark.stub(:prepare) { cm }
      get :prepare_bookmarklet, format: :js, l: valid_url
      assigns[:codemark].should == cm
    end

    it "passes off parsing params to a listener params parser"
    it "requires a user"
    it "what happens if codemark response isn't successful"

  end

  describe "#github" do
    it "prepares and saves a codemark" do
      cm = stub({
        :resource => stub.as_null_object,
        :topics => []
      })

      Codemark.stub(:prepare) { cm }
      Codemark.should_receive(:create)

      payload_from_github = git_commit_payload_example
      post :github, :payload => payload_from_github
    end
  end

  describe "#sendgrid" do
    it "works" do
      post :sendgrid, "headers"=>"Received: by 127.0.0.1 with SMTP id JsDJRDIx9C Sat, 10 Mar 2012 18:43:01 -0600 (CST)\nReceived: from na3sys010aob111.obsmtp.com (na3sys010aob111.obsmtp.com [74.125.245.89]) by mx3.sendgrid.net (Postfix) with SMTP id 2567114E65BC for <save@codemarks.org>; Sat, 10 Mar 2012 18:43:01 -0600 (CST)\nReceived: from mail-iy0-f182.google.com ([209.85.210.182]) (using TLSv1) by na3sys010aob111.postini.com ([74.125.244.12]) with SMTP ID DSNKT1v1FKdj3yCwqwqL+rRbEeiwedSN7Qyq@postini.com; Sat, 10 Mar 2012 16:43:00 PST\nReceived: by iahk25 with SMTP id k25so6999855iah.27 for <save@codemarks.org>; Sat, 10 Mar 2012 16:42:59 -0800 (PST)\nDKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=google; h=from:content-type:subject:date:message-id:to:mime-version:x-mailer; bh=Vp9UMLfgHfFrSKwhQ9RrLtgPzrw2OqfhSzYY78Qsh2Y=; b=gGnnm+geABmRkMIMGPxkeUed4exAd0zFD1ySwV2QzRM88K73VywcSWbrRi3q9u6dLq d4rHEpsKE+3mq6uIcquIBZ/tPTFSu3wjNzUzq7UBTNvMpbOtNvwWbf6KAbVhCIrncZuA HZY43YXl2jovTdPJEwV8Gefe55RU5wE+mji4o=\nX-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20120113; h=from:content-type:subject:date:message-id:to:mime-version:x-mailer :x-gm-message-state; bh=Vp9UMLfgHfFrSKwhQ9RrLtgPzrw2OqfhSzYY78Qsh2Y=; b=Zd1lBdmASpBZtrt8Erv7lZo2CI6eANOVkzwCvh3V+CIXO2SNowFtQizZ3bBTKCSG9E 8RGXsI4XWScBU4sFlzwbR4I8eKntr9LOyzL7A1nQx5KQOuKF5P61bxThefoXj1fq4Jr7 B+iV4Edy8VrnzCTl64S6q+WEzaYIqYn64pt8wAPvO5L9pDV+UOfLjRnQt+5/N4GXax1I TlXlvObU5rKcrpUEGeMMsseVd3EZac4KFkqyyMcxLYPJvD/zk+0KOMRrAnYWaxf0TKjO W9aRWUtkKgCa5S261fs1I8ToisZ6SERLVBDCR9uO+BzoVkkwVZDZ69cOnM1YjfBGWYA8 eRQg==\nReceived: by 10.50.100.202 with SMTP id fa10mr11918783igb.10.1331426579830; Sat, 10 Mar 2012 16:42:59 -0800 (PST)\nReceived: from [192.168.1.173] ([108.71.81.107]) by mx.google.com with ESMTPS id df2sm12550825igb.0.2012.03.10.16.42.58 (version=TLSv1/SSLv3 cipher=OTHER); Sat, 10 Mar 2012 16:42:59 -0800 (PST)\nFrom: Geoffrey Massanek <geoff@gmail.com>\nContent-Type: multipart/alternative; boundary=\"Apple-Mail=_451CEC02-BD8B-4E15-9356-9777778E3B9F\"\nSubject: \nDate: Sat, 10 Mar 2012 18:42:56 -0600\nMessage-Id: <61633E4B-58D1-46D4-A862-C7517E9EE487@gmail.com>\nTo: save@codemarks.org\nMime-Version: 1.0 (Apple Message framework v1257)\nX-Mailer: Apple Mail (2.1257)\nX-Gm-Message-State: ALoCoQkumWSbPwQ++2ki63G6WerHfRP5HbQYP8seBOArbIxd875UeC/B9F8nQ0D+JNptfUJt6Oec\n", "attachments"=>"0", "dkim"=>"{@gmail.com : fail (body has been altered)}", "subject"=>"", "to"=>"save@codemarks.org", "html"=>"<html><head></head><body style=\"word-wrap: break-word; -webkit-nbsp-mode: space; -webkit-line-break: after-white-space; \"><a href=\"http://coderwall.com/leaderboard\">http://coderwall.com/leaderboard</a></body></html>", "from"=>"Geoffrey Massanek <geoff@gmail.com>", "text"=>"http://coderwall.com/leaderboard", "envelope"=>"{\"to\":[\"save@codemarks.org\"],\"from\":\"geoff@gmail.com\"}", "charsets"=>"{\"to\":\"UTF-8\",\"html\":\"us-ascii\",\"subject\":\"UTF-8\",\"from\":\"UTF-8\",\"text\":\"us-ascii\"}", "SPF"=>"pass"
    end
  end
end


def git_commit_payload_example
  %! {\"pusher\":{\"name\":\"gmassanek\",\"email\":\"gmassanek@gmail.com\"},\"repository\":{\"name\":\"codemarks\",\"size\":160,\"has_wiki\":true,\"created_at\":\"2011/11/01 04:45:37 -0700\",\"private\":false,\"watchers\":5,\"fork\":false,\"language\":\"Ruby\",\"url\":\"https://github.com/gmassanek/codemarks\",\"pushed_at\":\"2012/03/10 11:47:36 -0800\",\"has_downloads\":true,\"open_issues\":20,\"homepage\":\"\",\"has_issues\":true,\"forks\":4,\"description\":\"\",\"owner\":{\"name\":\"gmassanek\",\"email\":\"gmassanek@gmail.com\"}},\"forced\":false,\"after\":\"280f3e53332cccdde6971378d347d05f6b20f8e0\",\"head_commit\":{\"modified\":[\"app/controllers/listener_controller.rb\"],\"added\":[],\"author\":{\"name\":\"Geoff Massanek (s)\",\"email\":\"geoff@massanek@gmail.com\"},\"timestamp\":\"2012-03-10T11:47:31-08:00\",\"removed\":[],\"url\":\"https://github.com/gmassanek/codemarks/commit/280f3e53332cccdde6971378d347d05f6b20f8e0\",\"id\":\"280f3e53332cccdde6971378d347d05f6b20f8e0\",\"distinct\":true,\"message\":\"[ci skip] More\",\"committer\":{\"name\":\"Geoff Massanek (s)\",\"email\":\"geoff@massanek@gmail.com\"}},\"deleted\":false,\"commits\":[{\"modified\":[\"app/controllers/listener_controller.rb\"],\"added\":[],\"author\":{\"name\":\"Geoff Massanek (s)\",\"email\":\"geoff@massanek@gmail.com\"},\"timestamp\":\"2012-03-10T11:46:51-08:00\",\"removed\":[],\"url\":\"https://github.com/gmassanek/codemarks/commit/f3f7a26790ed0cb9cd7a62d05f950f705ee39889\",\"id\":\"f3f7a26790ed0cb9cd7a62d05f950f705ee39889\",\"distinct\":true,\"message\":\"more #cm\",\"committer\":{\"name\":\"Geoff Massanek (s)\",\"email\":\"geoff@massanek@gmail.com\"}},{\"modified\":[\"app/controllers/listener_controller.rb\"],\"added\":[],\"author\":{\"name\":\"Geoff Massanek (s)\",\"email\":\"geoff@massanek@gmail.com\"},\"timestamp\":\"2012-03-10T11:47:31-08:00\",\"removed\":[],\"url\":\"https://github.com/gmassanek/codemarks/commit/280f3e53332cccdde6971378d347d05f6b20f8e0\",\"id\":\"280f3e53332cccdde6971378d347d05f6b20f8e0\",\"distinct\":true,\"message\":\"[ci skip] More\",\"committer\":{\"name\":\"Geoff Massanek (s)\",\"email\":\"geoff@massanek@gmail.com\"}}],\"ref\":\"refs/heads/master\",\"compare\":\"https://github.com/gmassanek/codemarks/compare/7763274...280f3e5\",\"before\":\"7763274bdb41666ac8c19883cc9a48a22d2b9bd5\",\"created\":false}!
end
