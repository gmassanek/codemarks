App.Codemark = Backbone.Model.extend
  urlRoot: '/codemarks'

  initialize: ->

  mine: ->
    @author().get('slug') == CURRENT_USER

  new: ->
    !@get('id')?

  exists: ->
    !@new()

  hasNewResource: ->
    @get('resource')? && !@get('resource').id?

  author: ->
    App.codemarks.users?.where({id: @get('user_id')})[0] || new App.User(@get('user'))
