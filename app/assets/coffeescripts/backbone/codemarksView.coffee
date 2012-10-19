App.CodemarksView = Backbone.View.extend
  initialize: ->
    @codemarks = @options.codemarks
    @codemarks.bind 'reset', => @render()

  render: ->
    @$el.html('')
    @$el.append(@newCodemarkTileHtml())
    @$el.append(@codemarksHtml())
    @$el.append(@paginationHtml())

  newCodemarkTileHtml: ->
    newCodemarkTile = new App.NewCodemarkTileView
    newCodemarkTile.render()
    newCodemarkTile.$el

  codemarksHtml: ->
    $codemarks = $('<div class="codemarks"></div>')
    for codemark in @codemarks.models
      codemarkView = new App.CodemarkView
        model: codemark
      codemarkView.render()
      $codemarks.append(codemarkView.$el)
    $codemarks

  paginationHtml: ->
    codemarkView = new App.PaginationView
      collection: @codemarks
    codemarkView.render()
    codemarkView.$el
