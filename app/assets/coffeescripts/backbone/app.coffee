define ['libs/jquery'], ($) ->

  start = ->
    $(document).ready ->
      $("body").html("Hello world!")

  return {"start":start}
