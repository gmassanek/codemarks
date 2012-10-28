App.Codemark = Backbone.Model.extend
  urlRoot : '/codemarks'

  initialize: ->

  mine: ->
    @get('author').slug == CURRENT_USER

  new: ->
    !@get('id')?

  exists: ->
    !@new()

  hasNewResource: ->
    @get('resource')? && !@get('resource').id?
