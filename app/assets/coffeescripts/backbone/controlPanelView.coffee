App.ControlPanelView = Backbone.View.extend
  className: 'controlPanel'

  events:
    'click .remove': 'removeFilter'

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

    @$el.append(@searchHtml())

  filterHtml: (value, type) ->
    template = angelo('filter.html')
    data =
      description: value
      'remove@data-type': type
      'remove@data-id': value
    facile(template, data)

  searchHtml: ->
    '<input id="search" name="search" type="text" placeholder="search...">'

  removeFilter: (e) ->
    $target = $(e.currentTarget)
    if $target.data('type') == 'topic'
      @removeTopic($target.data('id'))
    if $target.data('type') == 'user'
      @removeUser($target.data('id'))

  removeTopic: (topicId) ->
    @filters.removeTopic(topicId)
    @codemarks.fetch()

  removeUser: (username) ->
    @filters.removeUser()
    @codemarks.fetch()
