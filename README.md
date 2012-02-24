codemarks
=========

Development Environment Setup
-----------------------------

We're assuming you use homebrew and RVM, and developing on a mac:

    $ gem install bundler
    $ bundle install
    $ cp config/database.example.yml config/database.yml
    $ rake db:create:all
    $ rake db:reset
    $ rails server

### Running the Tests

    rake

Deployment Instructions
-----------------------

TODO
