App.MainRouter = Backbone.Router.extend
  routes:
    'codemarks?:params': 'codemarks'
    'codemarks': 'codemarks'

  codemarks: (params) ->
    @codemarks = App.codemarks
    @showCodemarkList()
    if params
      @codemarks.filters.loadFromCookie($.deparam(params))
    @codemarks.fetch()

  showCodemarkList: ->
    codemarkList = new App.CodemarksView
      el: $('#main_content')
      codemarks: @codemarks

    $('.content').html(codemarkList.$el)
