Fabricator(:sponsored_site) do
  topic! { Fabricate(:topic) }
  site { 'twitter' }
  url { |me| "http://www.#{me.site}.com/#{me.topic.title}" }
end
