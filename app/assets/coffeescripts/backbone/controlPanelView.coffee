App.ControlPanelView = Backbone.View.extend
  className: 'control-panel'

  events:
    'click a.search': 'searchClicked'
    'keypress input#search': 'searchKeyPress'

  initialize: ->
    @codemarks = @options.codemarks
    @codemarks.bind 'reset', => @render()
    App.topics.bind 'reset', => @render()
    @filters = @codemarks.filters

  render: ->
    @$el.html('')
    $filterDiv = $('<div class="filters"></div>')
    if @filters.get('user')
      user = @codemarks.users?.where(slug: @filters.get('user'))[0]
      desc = user?.get('nickname')
      val = user?.get('slug')
      img = user?.get('image')
      userHtml = @filterHtml(desc, val, 'user', img)
      $filterDiv.append(userHtml)

    _.each @filters.topicIds(), (topicId) =>
      topic = App.topics.where(slug: topicId)[0]
      desc = topic?.get('title')
      val = topic?.get('slug')
      topicHtml = @filterHtml(desc, val, 'topic')
      $filterDiv.append(topicHtml)

    if @filters.searchQuery()
      searchHtml = @filterHtml(@filters.searchQuery(), @filters.searchQuery(), 'query')
      $filterDiv.append(searchHtml)

    sortHtml = @filterHtml(@filters.get('sort'), @filters.get('sort'), 'sort')
    $filterDiv.append(sortHtml)

    $filterDiv.append('<div class="clear"></div>')
    @$el.append($filterDiv)
    @$el.append(@searchHtml())

  filterHtml: (desc, value, type, image = null) ->
    filterView = new App.FilterView
      description: desc
      type: type
      dataId: value
      image: image
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
