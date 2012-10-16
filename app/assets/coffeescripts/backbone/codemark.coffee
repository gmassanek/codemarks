App.Codemark = Backbone.Model.extend
  urlRoot : '/codemarks'

  initialize: ->

  mine: ->
    @get('author').slug == CURRENT_USER
