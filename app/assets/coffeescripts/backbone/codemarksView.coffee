App.CodemarksView = Backbone.View.extend
  className: 'codemarks'

  initialize: ->
    App.codemarks.bind 'reset', => @render()
    App.codemarks.bind 'add', (codemark) => @addCodemark(codemark)
    App.vent.bind('updateCodemarkRequest', => @renderAsLoading())
    @paginated = if @options.paginated? then @options.paginated else true
    @renderAsLoading()

  renderAsLoading: ->
    @$el.html(angelo('loading.html'))

  render: ->
    @$el.html('')
    @appendCodemarks()
    @$el.append(@paginationHtml()) if @paginated
    $("html, body").animate({ scrollTop: '0px'}, 200)

  appendCodemarks: ->
    for codemark in App.codemarks.models
      @$el.append(@codemarkHtml(codemark))

  codemarkHtml: (codemark) ->
    tile = new App.TileView
      model: codemark
      navigable: @options.navigable? || true
    tile.render()
    tile.$el

  paginationHtml: ->
    paginationView = new App.PaginationView
      collection: App.codemarks
    paginationView.render()
    paginationView.$el

  addCodemark: (codemark) ->
    @$el.prepend(@codemarkHtml(codemark))
