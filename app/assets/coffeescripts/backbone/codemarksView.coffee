App.CodemarksView = Backbone.View.extend
  className: 'codemarks'

  initialize: ->
    @codemarks = @options.codemarks
    @codemarks.bind 'reset', => @render()
    @codemarks.bind 'add', (codemark) => @addCodemark(codemark)

  render: ->
    @$el.html('')
    @appendNewCodemarkTile()
    @appendCodemarks()
    @$el.append(@paginationHtml())
    $("html, body").animate({ scrollTop: '0px'}, 200)

  appendNewCodemarkTile: ->
    if @noNewTile
      return
    @newCodemarkTile = new App.TileView
      add: true
    @newCodemarkTile.render()
    @$el.append(@newCodemarkTile.$el)

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

  addCodemark: (codemark) ->
    if @newCodemarkTile?
      @newCodemarkTile.$el.after(@codemarkHtml(codemark))
    else
      @$el.prepend(@codemarkHtml(codemark))
