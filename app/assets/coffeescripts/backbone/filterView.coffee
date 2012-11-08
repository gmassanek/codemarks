App.FilterView = Backbone.View.extend
  className: 'filter'
  template: angelo('filter.html')

  initialize: ->
    @codemarks = @options.codemarks
    @filters = @codemarks.filters

    data = @options.data
    @type = data.type
    @id = data.id
    @description = data.description
    @mode = data.mode

  events:
    'click .remove': 'remove'
    'click a.description': 'clicked'

  clicked: (e) ->
    e.preventDefault()
    if @type == 'topic'
      @navigateToTopic()
    if @type == 'user'
      @navigateToUser()

  render: ->
    html = facile(@template, @viewData())
    @$el.html(html)
    @$el.addClass(@mode)

  viewData: ->
    description: @description

  remove: (e) ->
    console.log 'remove'
    $target = $(e.currentTarget)
    if @type == 'topic'
      @removeTopic()
    if @type == 'user'
      @removeUser()

  navigateToTopic: ->
    @filters.setTopic(@id)
    @codemarks.fetch()

  navigateToUser: ->
    @filters.setUser(@id)
    @codemarks.fetch()

  removeTopic: ->
    @filters.removeTopic(@id)
    @codemarks.fetch()

  removeUser: ->
    @filters.removeUser()
    @codemarks.fetch()
