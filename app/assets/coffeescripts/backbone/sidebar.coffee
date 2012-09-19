window.Sidebar = {}
window.Sidebar.setSort = ->
  sort = App.codemarks.filters.get('sort')
  $('li.sort a').removeClass('active')
  $("li.sort a.#{sort}").addClass('active')

window.Sidebar.setFilters = ->
  user = App.codemarks.filters.username()
  Sidebar.activateUser(user)

  topic = App.codemarks.filters.topicId()
  Sidebar.renderTopic(topic)

window.Sidebar.activateUser = (user) ->
  $('li.nav').removeClass('active')
  if user
    $("li.nav a[data-user=#{user}]").closest('li').addClass('active')
  else
    $('li.nav a.public').closest('li').addClass('active')

window.Sidebar.renderTopic = (topic) ->
  $topic = $('li.nav a.topic').closest('li')
  $heading = $topic.prev('h3')
  $topic.remove()
  $heading.remove()

  if topic
    template = angelo('topic_filter')
    data =
      topic: topic
    html = facile(template, data)
    $('.sidebar ul').prepend(html)

    $('li.nav.topic_filter').delegate '.remove', 'click', (e) ->
      e.preventDefault()
      App.codemarks.filters.clearTopics()
      App.codemarks.fetch()

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

  $('.topic').click (e) ->
    e.preventDefault()
    App.codemarks.filters.clearUsers()
    App.codemarks.filters.addTopic($(e.currentTarget).attr('data-topic-id'))
    App.codemarks.fetch()

  $('.public').click (e) ->
    e.preventDefault()
    App.codemarks.filters.clearUsers()
    App.codemarks.fetch()

  $('.yours').click (e) ->
    e.preventDefault()
    App.codemarks.filters.addUser(CURRENT_USER)
    App.codemarks.fetch()

  $('li.sort a').click (e) ->
    e.preventDefault()
    App.codemarks.filters.setSort($(e.currentTarget).attr('data-by'))
    App.codemarks.fetch()

  App.codemarks.filters.bind 'change:sort', ->
    Sidebar.setSort()

  App.codemarks.filters.bind 'change:users', ->
    Sidebar.setFilters()

  App.codemarks.filters.bind 'change:topics', ->
    Sidebar.setFilters()

