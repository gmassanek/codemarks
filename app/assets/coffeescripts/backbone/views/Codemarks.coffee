App.Views.Codemarks = Backbone.View.extend
  className: 'codemarks'

  render: ->
    @toHTML()

  toHTML: ->
    for codemark in @collection.models
      codemarkView = new App.Views.Codemark
        model: codemark
      codemarkView.render()
      @$el.append(codemarkView.$el)
