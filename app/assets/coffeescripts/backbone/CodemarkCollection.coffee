define ['Codemark'], (Codemark) ->
  CodemarkCollection = Backbone.Collection.extend
    model: Codemark
    url: '/codemarks'

    initialize: ->
      @fetch ->
        console.log @models
