define ['CodemarkCollection', 'Codemark'], (CodemarkCollection, Codemark) ->
  MainRouter = Backbone.Router.extend
    routes:
      'codemarks': 'index'

    index: ->
      codemarks = new CodemarkCollection
      console.log codemarks
