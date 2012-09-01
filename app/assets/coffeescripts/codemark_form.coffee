window.CodemarkForm =
  handleNewTopics: ->
    $('#link_form_topic_autocomplete').keydown (event) ->
      if (event.keyCode == 13)
        event.preventDefault()
        if($('#link_form_topic_count').val() == '0')
          newTopic = $('#link_form_topic_autocomplete').val()
          existingCheckbox = $("#topic_chb_#{newTopic}")
          existingCheckbox = $(".title:contains('#{newTopic}')") if existingCheckbox.length == 0
          if(existingCheckbox.length == 0)
            newListItem = CodemarkForm.buildTopicListItem(newTopic)
            $("#topic_tags").append(newListItem)
          else
            existingCheckbox.closest('li').effect('highlight', {}, 2000)

          $('#link_form_topic_autocomplete').val('')
          $('#link_form_topic_slug').val('')

  buildTopicListItem: (newTopic) ->
    listItem = $("<li class='alert-message warning'></li>")
    listItem.append("<input checked='checked' id='topic_chb_#{newTopic}' name='new_topics[#{newTopic}]' type='hidden' value='#{newTopic}'>")
    listItem.append("<div class='title'>#{newTopic}</div>")
    listItem.append("<div class='delete'><a href='#'>X</a></div>")
    listItem.append("<div class='clear'></div>")

  prepareDeletes: ->
    $('#topic_tags').delegate '.delete', 'click', (event) ->
      event.preventDefault()
      $(event.currentTarget).closest("li").fadeOut 100, ->
        $(this).remove()

  bootstrap: ->
    CodemarkForm.prepareDeletes()
    Codemarks.prepareAutocompletes()
    CodemarkForm.handleNewTopics()
