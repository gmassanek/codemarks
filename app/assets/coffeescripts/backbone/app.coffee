define ['libs/jquery'], ($) ->
  console.log $

  start = ->
    $(document).ready ->
      $("body").html("Hello world!")

  return {"start":start}
