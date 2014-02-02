App.MainRouter = Backbone.Router.extend
  siteTail: ' | Codemarks'
  routes:
    '': 'codemarks'
    'codemarks': 'codemarks'
    'codemarks?:query': 'codemarks'
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
    document.title = App.codemarks.filters.dataForTitle() + @siteTail

    if !App.current_user.authorizedForGroup(App.codemarks.filters.get('group'))
      App.codemarks.filters.removeGroup()
      App.vent.trigger('updateCodemarkRequest')
      return

    @setCodemarksTab()
    @$container = $('#main_content')

    @setupTopics =>
      if !App.current_user.authorizedForTopics(App.codemarks.filters.topicIds())
        App.vent.trigger('updateCodemarkRequest')

    @renderControlPanel()
    @renderCodemarkList()
    App.codemarks.fetch()

  showCodemark: (id) ->
    @clearNav()
    codemark = new App.Codemark
      id: id
    codemark.fetch
      success: =>
        @view = new App.CodemarkShowView
          model: codemark
          el: $('.codemark')
        @view.render()

  setCodemarksTab: ->
    if App.codemarks.filters.hasUser(window.CURRENT_USER)
      @setActiveNav('yours')
    else
      @setActiveNav('everyones')

  showUser: (username) ->
    @setActiveNav('people')
    App.codemarks ||= new App.Codemarks
    App.codemarks.filters.setUser(username)
    App.codemarks.filters.setSort('popularity')
    @setActiveNav('people')
    @$container = $('.content')
    @setupTopics =>
      @renderCodemarkList()
      App.codemarks.fetch()

  userIndex: ->
    @setActiveNav('people')

  editUser: (username) ->
    @setActiveNav('people')

  about: ->

  topics: ->
    @setActiveNav('topics')

  updateUrlWithFilters: ->
    filterParams = $.param(App.codemarks.filters.data())
    if filterParams == ''
      url = "/codemarks"
    else
      url = "/codemarks?#{filterParams}"
    App.router.navigate(url, {trigger: true})

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
    $(".tabs li").removeClass('active')
    $(".tabs .#{activeNavClass}").closest('li').addClass('active')

  clearNav: ->
    $(".tabs li").removeClass('active')

  trackPageview: ->
    return unless _gaq?
    url = window.location.pathname + window.location.search
    _gaq.push(['_trackPageview', url])
