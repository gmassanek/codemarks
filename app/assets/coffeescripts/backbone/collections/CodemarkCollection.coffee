App.Collections.Codemarks = Backbone.Collection.extend
  model: App.Models.Codemark
  url: '/codemarks'

  initialize: ->
    @filters = new App.Models.Filters

  defaults:
    by: 'date'
    users: []

  fetch: ->
    Backbone.Collection.prototype.fetch.call(this, data: @filters.data())

  parse: (response) ->
    @pagination = response.pagination
    response.codemarks
