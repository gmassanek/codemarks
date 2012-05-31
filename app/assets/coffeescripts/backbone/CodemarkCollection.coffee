define ['Codemark'], (Codemark) ->
  CodemarkCollection = Backbone.Collection.extend
    model: Codemark

    initialize: (url)->
      @url = url || '/codemarks'
