App.CodemarksView = Backbone.View.extend
  initialize: ->
    @codemarks = @options.codemarks
    @codemarks.bind 'reset', => @render()

  render: ->
    #@renderControlPanel()
    @$el.html(@codemarksHtml())
    @$el.append(@paginationHtml())

  renderControlPanel: ->
    @sidebar ||= new App.SidebarView
      codemarks: @codemarks
    @sidebar.render()

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
