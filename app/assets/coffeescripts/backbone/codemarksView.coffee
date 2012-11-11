App.CodemarksView = Backbone.View.extend
  initialize: ->
    @codemarks = @options.codemarks
    @codemarks.bind 'reset', => @render()
    @codemarks.bind 'add', (data) => @addCodemark(data)

  render: ->
    @$el.html('')
    @$el.append(@renderControlPanel())
    @$el.append(@codemarksHtml())
    @$('.codemarks').prepend(@newCodemarkTileHtml())
    @$el.append(@paginationHtml())

    $('.codemarks').isotope
      itemSelector: '.tile'
      animationEngine: 'best-available'
      getSortData:
        views: ($elem) ->
          $elem.find('.views').text()

  newCodemarkTileHtml: ->
    newCodemarkTile = new App.TileView
      add: true
    newCodemarkTile.render()
    newCodemarkTile.$el

  renderControlPanel: ->
    controlPanel = new App.ControlPanelView
      codemarks: @codemarks
    controlPanel.render()
    controlPanel.$el

  codemarksHtml: ->
    $codemarks = $('<div class="codemarks"></div>')
    for codemark in @codemarks.models
      tile = @codemarkHtml(codemark)
      $codemarks.append(tile.$el)
    $codemarks

  codemarkHtml: (codemark) ->
    tile = new App.TileView
      model: codemark
    tile.render()
    tile

  paginationHtml: ->
    codemarkView = new App.PaginationView
      collection: @codemarks
    codemarkView.render()
    codemarkView.$el

  addCodemark: (data) ->
    codemark = new App.Codemark(data)
    tile = @codemarkHtml(codemark)
    @$('.codemarks').prepend(tile.$el)
