$ ->
  callback = -> window.close()

  $('#codemarklet #fetch').click (e)->
    e.preventDefault()
    $form = $('#codemark_form')
    url = $form.attr('action')

    $.post(url, $form.serialize(), (response) ->
      $("#codemarklet .cm_notice").show()
      setTimeout(callback, 2000)
    )
