App.ControlPanelView = Backbone.View.extend
  className: 'controlPanel'

  events:
    'click .remove': 'removeFilter'

  initialize: ->
    @codemarks = @options.codemarks
    @filters = @codemarks.filters

  render: ->
    @$el.html(@toHtml())

  toHtml: ->
    template = angelo('filter.html')
    $container = $('<div></div>')

    if @filters.get('user')
      data =
        description: @filters.get('user')
        'remove@data-type': 'user'
        'remove@data-id': @filters.get('user')
      html = facile(template, data)
      $container.append(html)

    _.each @filters.topicIds(), (topicId) ->
      data =
        description: topicId
        'remove@data-type': 'topic'
        'remove@data-id': topicId
      html = facile(template, data)
      $container.append(html)

    $container.html()

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
