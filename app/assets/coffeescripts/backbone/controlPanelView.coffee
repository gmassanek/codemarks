App.ControlPanelView = Backbone.View.extend
  className: 'controlPanel'

  events:
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

    html = @filterHtml(@filters.get('sort'), 'sort')
    @$el.append(html)

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
