require_relative 'seeder'

Seeder.clear_database
Seeder.create_topics(['commit', 'codemarks', 'rspec', 'capybara', 'jquery', 'css tricks'])
gmassanek = Seeder.create_me
jbeiber = Seeder.create_user('jbeiber')
carlyraejepsen = Seeder.create_user('carlyraejepsen')

urls = [
  'https://github.com/gmassanek/codemarks/pull/63',
  'http://rspec.info/',
  'https://github.com/rspec/rspec-core',
  'http://anthonyterrien.com/knob/'
]

urls.each do |url|
  Seeder.create_codemark(url, gmassanek)
end

Seeder.create_codemark('http://www.twitter.com/jbeiber', jbeiber)
Seeder.create_codemark('http://www.twitter.com/carlyraejepsen', carlyraejepsen)
