App.Codemarks = Backbone.Collection.extend
  model: App.Codemark
  url: '/codemarks'

  initialize: ->
    @filters = new App.Filters
    @bind 'all', @trackPageview

  trackPageview: ->
    return unless RAILS_ENV? && RAILS_ENV=='production'
    return if CURRENT_USER == 'gmassanek'
    query = $.param(@filters.data())
    _gaq.push(['_trackPageview', "/codemarks?#{query}"])

  fetch: ->
    Backbone.Collection.prototype.fetch.call(this, data: @filters.data())
    if App.router.onCodemarksPage()
      @filters.updateUrlWithFilters()

  parse: (response) ->
    @pagination = response.pagination
    response.codemarks
