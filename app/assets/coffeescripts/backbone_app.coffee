//= require underscore
//= require backbone
//= require facile
//= require angelo
//= require jquery.ba-bbq
//= require jquery.timeago

//= require backbone/app
//= require_tree ./backbone

$ ->
  unless ENV? && ENV == 'test'
    App.init()
