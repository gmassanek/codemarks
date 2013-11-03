App.ControlPanelView = Backbone.View.extend
  className: 'control-panel'

  events:
    'change input#search': 'search'

  initialize: ->
    App.codemarks.bind 'reset', => @render()
    App.topics.bind 'reset', => @render()
    @filters = App.codemarks.filters

  render: ->
    @$el.html('')
    $filterDiv = $('<div class="filters"></div>')
    if @filters.get('user')
      user = App.codemarks.users?.where(slug: @filters.get('user'))[0]
      desc = user?.get('nickname')
      val = user?.get('slug')
      img = user?.get('image')
      userHtml = @_filterHtml(desc, val, 'user', img)
      $filterDiv.append(userHtml)

    _.each @filters.topicIds(), (topicId) =>
      topic = App.topics.where(slug: topicId)[0]
      desc = topic?.get('title')
      val = topic?.get('slug')
      topicHtml = @_filterHtml(desc, val, 'topic')
      $filterDiv.append(topicHtml)

    if @filters.searchQuery()
      filterHtml = @_filterHtml(@filters.searchQuery(), @filters.searchQuery(), 'query')
      $filterDiv.append(filterHtml)

    sortHtml = @_filterHtml(@filters.get('sort'), @filters.get('sort'), 'sort')
    $filterDiv.append(sortHtml)

    $filterDiv.append('<div class="clear"></div>')
    @$el.append($filterDiv)
    @$el.append(@_searchHtml())
    @$('#search').select2
      tags: App.topics.slugs()

  search: (e) ->
    e?.preventDefault()
    return unless @_searchQuery()

    if _.include(App.topics.slugs(), @_searchQuery())
      App.codemarks.filters.addTopic(@_searchQuery())
      App.codemarks.filters.setPage(1)
    else
      App.codemarks.filters.setSearchQuery(@_searchQuery())

    App.vent.trigger('updateCodemarkRequest')

  _filterHtml: (desc, value, type, image = null) ->
    filterView = new App.FilterView
      description: desc
      type: type
      dataId: value
      image: image
      codemarks: App.codemarks

    filterView.render()
    filterView.$el

  _searchHtml: ->
    angelo('search.html')

  _searchQuery: ->
    @$('input#search').val()
