App.CodemarksView = Backbone.View.extend
  initialize: ->
    @codemarks = @options.codemarks
    @codemarks.bind 'reset', => @render()

  render: ->
    @$el.html(@renderControlPanel())
    @$el.append(@codemarksHtml())
    @$el.append(@paginationHtml())

  renderControlPanel: ->
    controlPanel = new App.ControlPanelView
      codemarks: @codemarks
    controlPanel.render()
    controlPanel.$el

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
