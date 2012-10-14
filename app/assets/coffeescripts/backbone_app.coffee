//= require underscore
//= require backbone
//= require facile
//= require angelo
//= require jquery.cookie
//= require jquery.ba-bbq

//= require backbone/app
//= require backbone/router
//= require_tree ./backbone/models
//= require_tree ./backbone
//= require_tree ./backbone/views

$ ->
  unless ENV? && ENV == 'test'
    App.init()
