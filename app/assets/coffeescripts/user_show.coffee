$ ->
  if $('#main_content.users.show').length > 0
    $('.side').delegate '.topic_link', 'click', (e) ->
      e.preventDefault()
      topicId = $(e.currentTarget).data('id')
      App.codemarks.filters.setTopic(topicId)
      App.codemarks.fetch()

