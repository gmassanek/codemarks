window.CodemarkForm =
  prepareDeletes: ->
    console.log $('#topic_tags')
    $('#topic_tags').delegate('.delete', 'click', (event) ->
      event.preventDefault()

      $(event.currentTarget).closest("li").fadeOut 100, ->
        $(this).remove()
        CodemarkForm.topics_count = $("#topic_tags li").length
        if(CodemarkForm.topics_count == 0)
          $("#codemark_form input[type=submit]").attr('disabled', 'disabled')
    )

  bindEnter: ->
    $("#codemark_form").keyup (event) ->
      console.log(event.keyCode)

      if (event.keyCode == 13)
        console.log 'Enter hit'
        event.stopPropagation()
        event.preventDefault()

  bootstrap: ->
    console.log 'here'
    CodemarkForm.prepareDeletes()
    CodemarkForm.bindEnter()
    CodemarkForm.topics_count = $("#topic_tags li").length

    Codemarks.prepareAutocompletes()

    if(CodemarkForm.topics_count == 0)
      $("#codemark_form input[type=submit]").attr('disabled', 'disabled')
