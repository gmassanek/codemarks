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
  'http://anthonyterrien.com/knob/',
  'http://icomoon.io/',
  'https://www.google.com/',
  'http://mylesmegyesi.blogspot.com/2011/11/tree-traversal-with-tail-recursion.html',
  'http://mylesmegyesi.blogspot.com/2011/11/minimax-depth.html',
  'http://paulirish.com/2012/box-sizing-border-box-ftw/',
  'https://github.com/nostalgiaz/bootstrap-toggle-buttons',
  'http://jetstrap.com/',
  'http://blog.8thlight.com/uncle-bob/2012/09/06/I-am-Your-New-CTO.html',
  'http://worrydream.com/LearnableProgramming/?utm_source=statuscode',
  'https://greenivy.mybalsamiq.com/projects',
  'http://diythemes.com/thesis/fun-fonts-logo/',
  'http://css-tricks.com/dont-overthink-it-grids/',
  'http://www.scribd.com/doc/232915/Ruby-PDFWriter-manual-pdf',
  'http://www.tenbytwenty.com/sosa.php',
  'http://help.airbrake.io/kb/troubleshooting-2/javascript-notifier',
  'http://ricostacruz.com/jquery.transit/',
  'http://vim-adventures.com/',
  'http://jroller.com/rolsen/entry/building_a_dsl_in_ruby',
  'http://stackoverflow.com/questions/2772407/good-books-on-ruby-based-dsl',
  'http://www.telestream.net/screen-flow/demos.htm'
]

urls.each do |url|
  p url
  Seeder.create_codemark(url, gmassanek)
end

Seeder.create_codemark('http://www.twitter.com/jbeiber', jbeiber)
Seeder.create_codemark('http://www.twitter.com/carlyraejepsen', carlyraejepsen)
