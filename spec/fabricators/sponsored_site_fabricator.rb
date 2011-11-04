Fabricator(:sponsored_site) do
  topic! { Fabricate(:topic) }
  site { 'twitter' }
  url { 'http://www.twitter.com/#/myhandle' }
end
