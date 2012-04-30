window.CodemarkForm =
  handleNewTopics: ->
    $("#link_form_topic_autocomplete").keydown (event) ->
      if (event.keyCode == 13)
        if($("#link_form_topic_count").val() == '0')
          event.preventDefault()

          newTopic = $("#link_form_topic_autocomplete").val()
          existingCheckbox = $("#topic_chb_#{newTopic}")
          if (existingCheckbox.length == 0)
            newListItem = CodemarkForm.buildTopicListItem(newTopic)
            $("#topic_tags").append(newListItem)
          else
            existingCheckbox.closest("li").effect("highlight", {}, 2000)

          $("#fetch").removeAttr("disabled")
          $("#link_form_topic_autocomplete").val("")
          $("#link_form_topic_slug").val("")

  buildTopicListItem: (newTopic) ->
    listItem = $("<li class='alert-message warning'></li>")
    listItem.append("<input checked='checked' id='topic_chb_#{newTopic}' name='topic_ids[#{newTopic}]' type='hidden' value='#{newTopic}'>")
    listItem.append("<div class='title'>#{newTopic}</div>")
    listItem.append("<div class='delete'><a href='#'>X</a></div>")
    listItem.append("<div class='clear'></div>")

  prepareDeletes: ->
    $('#topic_tags').delegate('.delete', 'click', (event) ->
      event.preventDefault()

      $(event.currentTarget).closest("li").fadeOut 100, ->
        $(this).remove()
        CodemarkForm.topics_count = $("#topic_tags li").length
        #if(CodemarkForm.topics_count == 0)
          #$("#codemark_form input[type=submit]").attr('disabled', 'disabled')
    )

  bindEnter: ->
    $("#codemark_form").keyup (event) ->
      if (event.keyCode == 13)
        event.stopPropagation()
        event.preventDefault()

  bootstrap: ->
    CodemarkForm.prepareDeletes()
    CodemarkForm.bindEnter()
    CodemarkForm.topics_count = $("#topic_tags li").length

    Codemarks.prepareAutocompletes()
    CodemarkForm.handleNewTopics()
