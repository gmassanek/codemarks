App.Views.CodemarkList = Backbone.View.extend
  className: 'codemarks'

  render: ->
    @toHTML()
    @$el.append(@paginationHTML())

  toHTML: ->
    console.log @collection.html
    @$el.append()

  paginationHTML: ->
    codemarkView = new App.Views.Pagination
      collection: App.codemarks
    codemarkView.render()
