App.Views.CodemarkList = Backbone.View.extend
  className: 'codemarks'

  render: ->
    @toHTML()
    @$el.append(@paginationHTML())

  toHTML: ->
    for codemark in @collection.models
      codemarkView = new App.Views.Codemark
        model: codemark
      codemarkView.render()
      @$el.append(codemarkView.$el)

  paginationHTML: ->
    codemarkView = new App.Views.Pagination
      collection: App.codemarks
    codemarkView.render()
