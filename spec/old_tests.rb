spec/controllers/listener_controller_spec.rb

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

