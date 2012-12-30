$ ->
  $('.side').delegate '.topic_link', 'click', (e) ->
    e.preventDefault()
    topicId = $(e.currentTarget).data('id')
    App.codemarks.filters.setTopic(topicId)
    App.codemarks.fetch()

