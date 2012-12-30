App.ControlPanelView = Backbone.View.extend
  className: 'controlPanel'

  events:
    'click a.search': 'searchClicked'
    'keypress input#search': 'searchKeyPress'

  initialize: ->
    @codemarks = @options.codemarks
    @codemarks.bind 'reset', => @render()
    @filters = @codemarks.filters

  render: ->
    @$el.html('')
    if @filters.get('user')
      userHtml = @filterHtml(@filters.get('user'), 'user')
      @$el.append(userHtml)

    _.each @filters.topicIds(), (topicId) =>
      topicHtml = @filterHtml(topicId, 'topic')
      @$el.append(topicHtml)

    if @filters.searchQuery()
      searchHtml = @filterHtml(@filters.searchQuery(), 'query')
      @$el.append(searchHtml)

    sortHtml = @filterHtml(@filters.get('sort'), 'sort')
    @$el.append(sortHtml)

    @$el.append(@searchHtml())

  filterHtml: (value, type) ->
    filterView = new App.FilterView
      description: value
      type: type
      dataId: value
      codemarks: @codemarks

    filterView.render()
    filterView.$el

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
