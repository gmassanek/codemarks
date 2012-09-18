App.Collections.Codemarks = Backbone.Collection.extend
  model: App.Models.Codemark
  url: '/codemarks'

  initialize: ->
    @filters = new App.Models.Filters
    @bind 'all', @trackPageview

  trackPageview: ->
    return unless RAILS_ENV? && RAILS_ENV=='production'
    query = $.param(@filters.data())
    _gaq.push(['_trackPageview', "/codemarks?#{query}"])

  defaults:
    by: 'date'
    users: []

  fetch: ->
    Backbone.Collection.prototype.fetch.call(this, data: @filters.data())

  parse: (response) ->
    @pagination = response.pagination
    response.codemarks
