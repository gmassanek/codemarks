define ['CodemarkCollection'], (CodemarkCollection) ->
  MainRouter = Backbone.Router.extend
    routes:
      'codemarks': 'index'

    index: ->
      codemarks = new CodemarkCollection
