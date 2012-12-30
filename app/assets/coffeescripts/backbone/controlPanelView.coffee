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
      user = @codemarks.users?.where(slug: @filters.get('user'))[0]
      desc = user?.get('nickname')
      val = user?.get('slug')
      userHtml = @filterHtml(desc, val, 'user')
      @$el.append(userHtml)

    _.each @filters.topicIds(), (topicId) =>
      topicHtml = @filterHtml(topicId, topicId, 'topic')
      @$el.append(topicHtml)

    if @filters.searchQuery()
      searchHtml = @filterHtml(@filters.searchQuery(), @filters.searchQuery(), 'query')
      @$el.append(searchHtml)

    sortHtml = @filterHtml(@filters.get('sort'), @filters.get('sort'), 'sort')
    @$el.append(sortHtml)

    @$el.append(@searchHtml())

  filterHtml: (desc, value, type) ->
    filterView = new App.FilterView
      description: desc
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
