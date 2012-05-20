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
