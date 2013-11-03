App.MainRouter = Backbone.Router.extend
  routes:
    '': 'codemarks'
    'codemarks': 'codemarks'
    'users/:username': 'showUser'
    'users/:username/edit': 'editUser'
    'users(?page=:page)': 'userIndex'
    'about': 'about'
    'topics': 'topics'

  codemarks: ->
    params = window.location.search.substring(1)
    @codemarks = App.codemarks = new App.Codemarks
    @codemarks.filters.loadFromCookie($.deparam(params || ''))
    @$container = $('#main_content')
    @$container.html('')
    @setupTopics =>
      @renderControlPanel()
      @renderCodemarkList()
      @codemarks.fetch()

  showUser: (username) ->
    @codemarks = App.codemarks = new App.Codemarks
    @codemarks.filters.setUser(username)
    @codemarks.filters.setSort('visits')
    @setActiveNav('people')
    @setupTopics =>
      @$container = $('.content')
      @renderCodemarkList()
      @codemarksView.noNewTile = true
      @codemarks.fetch()

  editUser: (username) ->

  userIndex: ->
    @setActiveNav('people')

  about: ->

  topics: ->

  updateUrlWithFilters: ->
    filterParams = $.param(@codemarks.filters.data())
    if filterParams == ''
      url = "/codemarks?"
    else
      url = "/codemarks?#{filterParams}"

    App.router.navigate(url, {trigger: true})
    Backbone.history.stop(); Backbone.history.start({pushState: true})
    #Backbone.history.loadUrl(url)
    #Backbone.history.reload()

  updateCodemarks: ->
    @updateUrlWithFilters()

  renderControlPanel: ->
    controlPanel = new App.ControlPanelView
      codemarks: @codemarks
    controlPanel.render()
    @$container.append(controlPanel.$el)

  renderCodemarkList: ->
    @codemarksView = new App.CodemarksView
      codemarks: @codemarks
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
    return unless _gaq?
    url = window.location.pathname + window.location.search
    _gaq.push(['_trackPageview', url])
