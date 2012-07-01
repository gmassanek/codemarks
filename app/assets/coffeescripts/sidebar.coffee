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

  $('.mine').click (e) ->
    e.preventDefault()
    App.router.user = 'gmassanek'
    App.router.navigate('massanek', {trigger: true})

  $('li.sort a').click (e) ->
    e.preventDefault()
    App.codemarks = new App.Collections.Codemarks
      by: $(e.currentTarget).attr('data-by')
    App.codemarks.flush(@showCodemarkList)
    #App.setActiveSort $(e.currentTarget)
