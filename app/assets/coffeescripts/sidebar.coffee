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

  $('.public').click (e) ->
    e.preventDefault()
    App.router.navigate('public', {trigger: true})

  $('li.sort a').click (e) ->
    e.preventDefault()
    App.codemarks = new App.Collections.Codemarks
      by: $(e.currentTarget).attr('data-by')
    App.codemarks.flush(@showCodemarkList)
    #App.setActiveSort $(e.currentTarget)
