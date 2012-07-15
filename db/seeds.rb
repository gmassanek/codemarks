require_relative 'seeder'

Seeder.clear_database
Seeder.create_topics(['commit', 'codemarks', 'rspec', 'capybara', 'jquery', 'css tricks'])
jbeiber = Seeder.create_user('jbeiber')
jbeiber = Seeder.create_user('jbeiber')

urls = [
  'https://github.com/gmassanek/codemarks/pull/63',
  'http://rspec.info/',
  'https://github.com/rspec/rspec-core',
  'http://anthonyterrien.com/knob/'
]

urls.each do |url|
  Seeder.create_codemark(url, jbeiber)
end
