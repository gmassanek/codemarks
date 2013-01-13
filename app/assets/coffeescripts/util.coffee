window.setFlash = (type, message)->
  template = angelo('flash.html')
  data = { message: message }

  $('.alert').remove()

  $html = $(facile(template, data))
  $html.addClass(type)
  $('body').prepend($html)
  if type == 'notice'
    $html.delay(5000).fadeOut(1000)
