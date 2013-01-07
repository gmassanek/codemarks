App.TabsView = Backbone.View.extend

  events:
    'click .yours': 'clickYours'
    'click .everyones': 'clickEveryones'
    'click .disabled': 'clickDisabled'

  initialize: ->
    @codemarks = @options.codemarks
    @filters = @codemarks.filters
    @codemarks.bind 'reset', => @selectActiveTab()

  clickYours: (e) ->
    e.preventDefault()
    @$('li').removeClass('active')
    @filters.reset()
    @filters.setUser(CURRENT_USER)
    @codemarks.fetch()

  clickEveryones: (e) ->
    e.preventDefault()
    @$('li').removeClass('active')
    @filters.reset()
    @codemarks.fetch()

  clickDisabled: (e) ->
    e.preventDefault()

  selectActiveTab: ->
    @$('.active').removeClass('active')
    unless App.router.onCodemarksPage()
      return

    if CURRENT_USER? && @filters.hasUser(CURRENT_USER)
      @$('.yours').closest('li').addClass('active')
    else
      @$('.everyones').closest('li').addClass('active')
