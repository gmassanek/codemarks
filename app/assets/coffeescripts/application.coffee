//= require jquery
//= require jquery_ujs

//= require underscore
//= require backbone
//= require facile
//= require angelo
//= require jquery.ba-bbq
//= require jquery.timeago
//= require select2

//= require backbone/app
//= require_tree ./backbone
//= require user_show
//= require user_edit

$ ->
  $(".flash.notice").delay(3000).fadeOut(1000)
  $(".flash a.remove").click (e) ->
    e.preventDefault()
    $(e.currentTarget).closest('.flash').fadeOut(1000)

  unless ENV? && ENV=='jasmine'
    App.init()
