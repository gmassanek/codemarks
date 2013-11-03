App.CodemarksView = Backbone.View.extend
  className: 'codemarks'

  initialize: ->
    App.codemarks.bind 'reset', => @render()
    App.codemarks.bind 'add', (codemark) => @addCodemark(codemark)
    App.vent.bind('updateCodemarkRequest', => @renderAsLoading())
    @renderAsLoading()

  renderAsLoading: ->
    @$el.html(angelo('loading.html'))

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
    for codemark in App.codemarks.models
      @$el.append(@codemarkHtml(codemark))

  codemarkHtml: (codemark) ->
    tile = new App.TileView
      model: codemark
    tile.render()
    tile.$el

  paginationHtml: ->
    paginationView = new App.PaginationView
      collection: App.codemarks
    paginationView.render()
    paginationView.$el

  addCodemark: (codemark) ->
    if @newCodemarkTile?
      @newCodemarkTile.$el.after(@codemarkHtml(codemark))
    else
      @$el.prepend(@codemarkHtml(codemark))
