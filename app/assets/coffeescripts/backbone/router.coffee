App.MainRouter = Backbone.Router.extend
  routes:
    '': 'codemarks'
    'codemarks': 'codemarks'
    'codemarks/:id': 'showCodemark'
    'users/:username': 'showUser'
    'users/:username/edit': 'editUser'
    'users(?page=:page)': 'userIndex'
    'about': 'about'
    'topics': 'topics'

  codemarks: ->
    params = window.location.search.substring(1)
    App.codemarks ||= new App.Codemarks
    App.codemarks.filters.loadFromCookie($.deparam(params || ''))
    @$container = $('#main_content')
    @setupTopics =>
      @renderControlPanel()
      @renderCodemarkList()
      App.codemarks.fetch()

  showCodemark: ->

  showUser: (username) ->
    App.codemarks ||= new App.Codemarks
    App.codemarks.filters.setUser(username)
    App.codemarks.filters.setSort('visits')
    @setActiveNav('people')
    @$container = $('.content')
    @setupTopics =>
      @renderCodemarkList()
      @codemarksView.noNewTile = true
      App.codemarks.fetch()

  editUser: (username) ->

  userIndex: ->
    @setActiveNav('people')

  about: ->

  topics: ->

  updateUrlWithFilters: ->
    filterParams = $.param(App.codemarks.filters.data())
    if filterParams == ''
      url = "/codemarks?"
    else
      url = "/codemarks?#{filterParams}"

    App.router.navigate(url, {trigger: true})
    Backbone.history.stop(); Backbone.history.start({pushState: true})

  updateCodemarks: ->
    @updateUrlWithFilters()

  renderControlPanel: ->
    if !@controlPanel?
      @controlPanel = new App.ControlPanelView
      @$container.append(@controlPanel.$el)
    @controlPanel.render()

  renderCodemarkList: ->
    if !@codemarksView?
      @codemarksView = new App.CodemarksView
      @$container.append(@codemarksView.$el)

  setupTopics: (callback) ->
    if App.topics?
      callback?()
    else
      App.topics = new App.Topics
      App.topics.fetch( success: => callback?() )

  setActiveNav: (activeNavClass) ->
    $(".tabs .#{activeNavClass}").closest('li').addClass('active')

  trackPageview: ->
    console.log 'hi'
    return unless _gaq?
    url = window.location.pathname + window.location.search
    _gaq.push(['_trackPageview', url])
