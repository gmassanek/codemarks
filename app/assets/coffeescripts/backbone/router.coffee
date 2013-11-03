App.MainRouter = Backbone.Router.extend
  routes:
    '': 'codemarks'
    'codemarks': 'codemarks'
    'users/:username': 'showUser'
    'users(?page=:page)': 'userIndex'

  codemarks: ->
    params = window.location.search.substring(1)
    @codemarks = App.codemarks = new App.Codemarks
    @codemarks.filters.loadFromCookie($.deparam(params || ''))
    @$container = $('#main_content')
    @$container.html('')
    @setupTopics()

    @renderControlPanel()
    @renderCodemarkList()
    @codemarks.fetch()
    @trackPageview()

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
    console.log 'updating!'
    @updateUrlWithFilters()

  showUser: (username) ->
    @codemarks = App.codemarks = new App.Codemarks
    @codemarks.filters.setUser(username)
    @codemarks.filters.setSort('visits')
    @setupTopics()

    @$container = $('.content')
    @renderCodemarkList()
    @codemarksView.noNewTile = true
    @codemarks.fetch()
    @setActiveNav('people')

  userIndex: ->
    @setActiveNav('people')

  renderControlPanel: ->
    controlPanel = new App.ControlPanelView
      codemarks: @codemarks
    controlPanel.render()
    @$container.append(controlPanel.$el)

  renderCodemarkList: ->
    @codemarksView = new App.CodemarksView
      codemarks: @codemarks
    @$container.append(@codemarksView.$el)

  setupTopics: ->
    App.topics = new App.Topics
    App.topics.fetch()

  onCodemarksPage: ->
    (Backbone.history.fragment.match(/^codemarks/) || Backbone.history.fragment.match(/^\/codemarks/))?

  setActiveNav: (activeNavClass) ->
    $(".tabs .#{activeNavClass}").closest('li').addClass('active')

  trackPageview: ->
    return unless _gaq?
    _gaq.push(['_trackPageview', "/codemarks?#{$.param(@filters.data())}"])
