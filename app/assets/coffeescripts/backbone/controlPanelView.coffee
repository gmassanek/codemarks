App.ControlPanelView = Backbone.View.extend
  className: 'controlPanel'

  events:
    'click .remove': 'removeFilter'
    'click a.search': 'searchClicked'
    'keypress input#search': 'searchKeyPress'

  initialize: ->
    @codemarks = @options.codemarks
    @filters = @codemarks.filters

  render: ->
    if @filters.get('user')
      html = @filterHtml(@filters.get('user'), 'user')
      @$el.append(html)

    _.each @filters.topicIds(), (topicId) =>
      html = @filterHtml(topicId, 'topic')
      @$el.append(html)

    if @filters.searchQuery()
      html = @filterHtml(@filters.searchQuery(), 'query')
      @$el.append(html)

    @$el.append(@searchHtml())

  filterHtml: (value, type) ->
    template = angelo('filter.html')
    data =
      description: value
      'remove@data-type': type
      'remove@data-id': value
    facile(template, data)

  searchHtml: ->
    angelo('search.html')

  search: ->
    if @searchQuery()
      @filters.setSearchQuery(@searchQuery())
      @codemarks.fetch()

  searchClicked: (e) ->
    e.preventDefault()
    @search()

  searchQuery: ->
    @$('input#search').val()

  searchKeyPress: (e) ->
    if e.which == 13
      e.preventDefault()
      @search()

  removeFilter: (e) ->
    $target = $(e.currentTarget)
    if $target.data('type') == 'topic'
      @removeTopic($target.data('id'))
    if $target.data('type') == 'user'
      @removeUser($target.data('id'))
    if $target.data('type') == 'query'
      @removeSearchQuery()

  removeTopic: (topicId) ->
    @filters.removeTopic(topicId)
    @codemarks.fetch()

  removeUser: (username) ->
    @filters.removeUser()
    @codemarks.fetch()

  removeSearchQuery: ->
    @filters.clearSearchQuery()
    @codemarks.fetch()
