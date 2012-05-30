define ['CodemarksView'], (CodemarksView) ->
  CodemrksView = Backbone.View.extend
    container: 'codemarks'

    initialize: ->

    render: ->
      @$el.append(@toHTML())

    toHTML: ->
      for codemark in @collection.models
        console.log 'models'

      '<h1>Hello World</h1'
        


