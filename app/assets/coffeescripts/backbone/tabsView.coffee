App.TabsView = Backbone.View.extend
  events:
    'click .yours': 'clickYours'
    'click .everyones': 'clickEveryones'
    'click .disabled': 'clickDisabled'

  initialize: ->
    @codemarks = @options.codemarks
    @filters = @codemarks.filters

  clickYours: (e) ->
    e.preventDefault()
    @$('li').removeClass('active')
    $(e.currentTarget).closest('li').addClass('active')
    @filters.reset()
    @filters.setUser(CURRENT_USER)
    @codemarks.fetch()

  clickEveryones: (e) ->
    e.preventDefault()
    @$('li').removeClass('active')
    $(e.currentTarget).closest('li').addClass('active')
    @filters.reset()
    @codemarks.fetch()

  clickDisabled: (e) ->
    e.preventDefault()
