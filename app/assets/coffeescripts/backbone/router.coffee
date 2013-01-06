App.MainRouter = Backbone.Router.extend
  routes:
    '': 'codemarks'
    'codemarks?:params': 'codemarks'
    'codemarks': 'codemarks'
    'users/:username': 'showUser'

  codemarks: (params) ->
    @codemarks = App.codemarks = new App.Codemarks
    @codemarks.filters.loadFromCookie($.deparam(params || ''))
    @$container = $('#main_content')
    @$container.html('')
    @setupTopics()

    @renderTabsNav()
    @renderControlPanel()
    @renderCodemarkList()
    @codemarks.fetch()

  showUser: (username) ->
    @codemarks = App.codemarks = new App.Codemarks
    @codemarks.filters.setUser(username)
    @codemarks.filters.setSort('visits')
    @setupTopics()

    @$container = $('.content')
    @renderCodemarkList()
    @codemarksView.noNewTile = true
    @codemarks.fetch()

  renderControlPanel: ->
    controlPanel = new App.ControlPanelView
      codemarks: @codemarks
    controlPanel.render()
    @$container.append(controlPanel.$el)

  renderCodemarkList: ->
    @codemarksView = new App.CodemarksView
      codemarks: @codemarks
    @$container.append(@codemarksView.$el)

  renderTabsNav: ->
    new App.TabsView
      el: $('nav ul.tabs')
      codemarks: @codemarks

  setupTopics: ->
    App.topics = new App.Topics
    App.topics.fetch()

  onCodemarksPage: ->
    (Backbone.history.fragment.match(/^codemarks/) || Backbone.history.fragment.match(/^\/codemarks/))?
