window.Codemarklet =
  closeWindowOnEscape: ->
    $(document).keyup (event) ->
      if (event.keyCode == 27)
        window.close()

  setupSubmit: ->
    $("#codemark_form").submit (event) ->
      event.preventDefault()
      $cm_form = $(event.currentTarget)
      data = $cm_form.serialize()
      url = $cm_form.attr('action')
      $.post url, data, Codemarklet.successfulPost, 'SCRIPT'

  successfulPost: (response) ->
    console.log response
    $('.cm_notice').show()
    delay = (ms, func) -> setTimeout func, ms

    delay 1500, -> window.close()

  bootstrap: ->
    $ ->
      Codemarklet.closeWindowOnEscape()
      Codemarklet.setupSubmit()
      window.CodemarkForm.bootstrap()
