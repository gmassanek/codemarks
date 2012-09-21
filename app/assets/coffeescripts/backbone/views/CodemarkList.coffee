App.Views.CodemarkList = Backbone.View.extend
  initialize: ->
    App.codemarks.bind 'reset', => @render()

  render: ->
    @$el.html(@codemarks())

  codemarks: ->
    $codemarks = $('<div class="codemarks"></div>')
    for codemark in App.codemarks.models
      codemarkView = new App.Views.Codemark
        model: codemark
      codemarkView.render()
      $codemarks.append(codemarkView.$el)
    $codemarks.append(@pagination())
    $codemarks

  pagination: ->
    codemarkView = new App.Views.Pagination
      collection: App.codemarks
    codemarkView.render()
    codemarkView.$el
