//= require underscore
//= require backbone
//= require facile
//= require angelo
//= require jquery.ba-bbq
//= require jquery.timeago.js
//= require jquery.isotope.js

//= require backbone/app
//= require_tree ./backbone

$ ->
  unless ENV? && ENV == 'test'
    App.init()
