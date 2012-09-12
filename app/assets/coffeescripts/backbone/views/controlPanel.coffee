App.Views.ControlPanel = Backbone.View.extend
  initialize: ->
    App.codemarks.bind 'reset', => @render()
    @filters = App.codemarks.filters

  events:
    'change #yours': 'clickYours'
    'click .sort a': 'sortClicked'

  render: ->
    @$el.append(@toHTML())

  template: angelo('controlPanel.html')

  toHTML: ->
    $html = $(facile(@template, @presentedAttributes()))
    $html.find(".#{@filters.get('sort')}").addClass('active')
    if App.codemarks.filters.hasUser(CURRENT_USER)
      $html.find("#yours").attr('checked', true)
    $html

  presentedAttributes: ->
    users: @presentUsers()
    topics: @presentTopics()

  presentUsers: ->
    _.map @filters.usernames(), (username) ->
      {user: username}

  presentTopics: ->
    _.map @filters.topicIds(), (topic_id) ->
      {topic: topic_id}

  filters: ->
    App.codemarks.filters

  clickYours: (e) ->
    e.preventDefault()
    checked = $(e.currentTarget).is(':checked')
    if checked
      @filters.addUser(CURRENT_USER)
    else
      @filters.removeUser(CURRENT_USER)
    App.codemarks.fetch()

  sortClicked: (e) ->
    e.preventDefault()
    sort = $(e.currentTarget).text()
    @filters.setSort(sort)
    App.codemarks.fetch()
