App.Codemarks = Backbone.Collection.extend
  model: App.Codemark
  url: '/codemarks'

  initialize: ->
    @filters = new App.Filters

  fetch: ->
    Backbone.Collection.prototype.fetch.call(this, data: @filters.data())

  parse: (response) ->
    @pagination = response.pagination
    @users = new Backbone.Collection(response.users)
    response.codemarks
