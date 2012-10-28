App.CodemarksView = Backbone.View.extend
  initialize: ->
    @codemarks = @options.codemarks
    @codemarks.bind 'reset', => @render()
    @codemarks.bind 'add', (codemark) => @addCodemark(codemark)

  render: ->
    @$el.html('')
    @$el.append(@newCodemarkTileHtml())
    @$el.append(@codemarksHtml())
    @$el.append(@paginationHtml())

    @newCodemarkTile.bind 'turnIntoForm', => @turnTileIntoForm(@newCodemarkTile)

  newCodemarkTileHtml: ->
    #@newCodemarkTile = new App.NewCodemarkTileView
    @newCodemarkTile = new App.TileView
    @newCodemarkTile.render()
    @newCodemarkTile.$el

  codemarksHtml: ->
    $codemarks = $('<div class="codemarks"></div>')
    for codemark in @codemarks.models
      codemarkView = new App.TileView
        model: codemark
      codemarkView.render()
      $codemarks.append(codemarkView.$el)
      codemarkView.bind 'turnIntoForm', (view) => @turnTileIntoForm(view)
    $codemarks

  paginationHtml: ->
    codemarkView = new App.PaginationView
      collection: @codemarks
    codemarkView.render()
    codemarkView.$el

  turnTileIntoForm: (view) ->
    form = new App.CodemarkFormView
      model: view.codemark || view.model
    form.render()

    form.bind 'cancel', => @cancelForm(form)
    form.bind 'updated', => @cancelForm(form)
    form.bind 'created', (data) => @addCodemark(data)
    form.bind 'created', => @cancelForm(form)

    view.$el.replaceWith(form.$el)

  cancelForm: (view) ->
    if view.mode() == 'new'
      @replaceNewCodemarkTile(view)
    else
      @turnIntoShow(view)

  turnIntoShow: (view) ->
    form = new App.CodemarkView
      model: view.codemark || view.model
    form.render()
    view.$el.replaceWith(form.$el)

  replaceNewCodemarkTile: (view) ->
    $newEl = @newCodemarkTileHtml()
    view.$el.replaceWith($newEl)

  addCodemark: (data) ->
    codemark = new App.Codemark(data)
    codemarkView = new App.CodemarkView
      model: codemark
    codemarkView.render()
    @$('.codemarks').prepend(codemarkView.$el)
