define ['CodemarksView', 'CodemarkView'], (CodemarksView, CodemarkView) ->
  CodemrksView = Backbone.View.extend
    initialize: ->

    render: ->
      @$el.append(@toHTML())

    toHTML: ->
      $fil = $('<div class="codemarks"></div>')
      for codemark in @collection.models
        codemarkView = new CodemarkView
          model: codemark
        codemarkView.render()
        $fil.append(codemarkView.$el)
      $fil
