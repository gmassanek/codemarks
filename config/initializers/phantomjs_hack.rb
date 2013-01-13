if Rails.env.test?
  require 'rack/contrib/simple_endpoint'
  Rails.application.config.middleware.insert_after Rack::Runtime, Rack::SimpleEndpoint, /\.ttf$/ do |req, res|
    ua = req.env['HTTP_USER_AGENT']
    if ua =~ /Intel Mac OS X.*PhantomJS/
      res.status = 403
      "Denying #{req.fullpath} to #{ua}"
    else
      :pass
    end
  end
end
