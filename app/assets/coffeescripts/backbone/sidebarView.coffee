App.SidebarView = Backbone.View.extend
  el: '.sidebar'

  events:
    'keydown #site_search': 'searchOnEnter'
    'click #site_search': 'search'
    'click .public': 'clearUsers'
    'click .yours': 'filterByCurrentUser'
    'click .sort a': 'setMySort'
    'click .reset': 'clearFilters'
    'click .remove': 'removeTopic'

  searchOnEnter: (e) ->
    if (e.keyCode == 13)
      @search(e)

  clearUsers: (e) ->
    e.preventDefault()
    @codemarks.filters.clearUsers()
    @codemarks.fetch()

  filterByCurrentUser: (e) ->
    e.preventDefault()
    @codemarks.filters.addUser(CURRENT_USER)
    @codemarks.fetch()

  setMySort: (e) ->
    e.preventDefault()
    @codemarks.filters.setSort($(e.currentTarget).attr('data-by'))
    @codemarks.fetch()

  clearFilters: (e) ->
    e.preventDefault()
    @codemarks.filters.reset()
    @codemarks.fetch()

  removeTopic: (e) ->
    e.preventDefault()
    @codemarks.filters.clearTopics()
    @codemarks.fetch()

  search: (e) ->
    event.preventDefault()
    query = @$('#site_search').val()
    if query
      window.location = "/codemarks/search/#{query}"

  initialize: ->
    @codemarks = @options.codemarks
    @codemarks.filters.bind 'change', => @render()

  render: ->
    user = @codemarks.filters.get('user')
    @activateUser(user)

    topic = @codemarks.filters.topicId()
    @renderTopic(topic)

    sort = @codemarks.filters.get('sort')
    @activateSort(sort)

  activateSort: (sort)->
    @$('li.sort a').removeClass('active')
    @$("li.sort a.#{sort}").addClass('active')

  activateUser: (user) ->
    @$('li.nav').removeClass('active')
    if user
      @$("li.nav a[data-user=#{user}]").closest('li').addClass('active')
    else
      @$('li.nav a.public').closest('li').addClass('active')

  renderTopic: (topic) ->
    $topic = @$('li.nav a.topic').closest('li')
    $heading = $topic.prev('h3')
    $topic.remove()
    $heading.remove()

    if topic
      template = angelo('topic_filter')
      data =
        topic: topic
      html = facile(template, data)
      @$('ul').prepend(html)
