$ ->
  $('#site_search').keydown (event) ->
    if (event.keyCode == 13)
      event.preventDefault()
      $('#site_search_submit').click()

  $('#site_search_submit').click (event) ->
    event.preventDefault()
    query = $('#site_search').val()
    if query
      window.location = "/codemarks/search/#{query}"

  $('.yours').click (e) ->
    e.preventDefault()
    username = $(e.currentTarget).attr('data-user')
    App.router.navigate(username, {trigger: true})

  $('.topic').click (e) ->
    e.preventDefault()
    topic_id = $(e.currentTarget).attr('data-topic-id')
    App.router.navigate("/topics/#{topic_id}", {trigger: true})

  $('.your_topic').click (e) ->
    e.preventDefault()
    username = $(e.currentTarget).attr('data-user')
    topic_id = $(e.currentTarget).attr('data-topic-id')
    App.router.navigate("#{username}?topic_id=#{topic_id}", {trigger: true})

  $('.public').click (e) ->
    e.preventDefault()
    App.router.navigate('public', {trigger: true})

  $('li.sort a').click (e) ->
    e.preventDefault()
    App.codemarks = new App.Collections.Codemarks
      by: $(e.currentTarget).attr('data-by')
    App.codemarks.flush(@showCodemarkList)
    #App.setActiveSort $(e.currentTarget)
