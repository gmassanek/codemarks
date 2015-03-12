//= require jquery
//= require jquery_ujs
//= require jquery-ui-1.10.3.custom.min

//= require underscore
//= require backbone
//= require facile
//= require angelo
//= require jquery.ba-bbq
//= require jquery.timeago
//= require jquery.fileupload
//= require jquery.iframe-transport
//= require select2
//= require tooltip

//= require util

//= require backbone/app
//= require backbone/modalView
//= require_tree ./backbone
//= require user_show
//= require user_edit

$ ->
  $(".flash.notice").delay(3000).fadeOut(1000)
  $('body').delegate ".flash a.remove", 'click', (e) ->
    e.preventDefault()
    $(e.currentTarget).closest('.flash').fadeOut(1000)

  unless ENV? && ENV=='jasmine'
    App.init()
