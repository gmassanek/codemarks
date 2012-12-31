//= require jquery
//= require jquery_ujs

$ ->
  $(".flash.notice").delay(3000).fadeOut(1000)
  $(".flash a.remove").click (e) ->
    e.preventDefault()
    $(e.currentTarget).closest('.flash').fadeOut(1000)
