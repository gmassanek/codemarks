App.CodemarksView = Backbone.View.extend
  className: 'codemarks'

  initialize: ->
    @codemarks = @options.codemarks
    @codemarks.bind 'reset', => @render()
    @codemarks.bind 'add', (data) => @addCodemark(data)

  render: ->
    @$el.html('')
    @appendCodemarks()
    @$el.append(@paginationHtml())

  appendCodemarks: ->
    for codemark in @codemarks.models
      @$el.append(@codemarkHtml(codemark))

  codemarkHtml: (codemark) ->
    tile = new App.TileView
      model: codemark
    tile.render()
    tile.$el

  paginationHtml: ->
    paginationView = new App.PaginationView
      collection: @codemarks
    paginationView.render()
    paginationView.$el

  addCodemark: (data) ->
    codemark = new App.Codemark(data)
    @$el.prepend(@codemarkHtml(codemark))
