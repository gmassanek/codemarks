define ['CodemarksView', 'CodemarkView'], (CodemarksView, CodemarkView) ->
  CodemrksView = Backbone.View.extend
    className: 'codemarks'

    render: ->
      @toHTML()

    toHTML: ->
      for codemark in @collection.models
        codemarkView = new CodemarkView
          model: codemark
        codemarkView.render()
        @$el.append(codemarkView.$el)
