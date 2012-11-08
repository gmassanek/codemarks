App.MainRouter = Backbone.Router.extend
  routes:
    'codemarks?:params': 'codemarks'
    'codemarks': 'codemarks'

  codemarks: (params) ->
    @codemarks = App.codemarks
    App.topics = new App.Topics
    App.topics.fetch()
    @showCodemarkList()
    @codemarks.filters.loadFromCookie($.deparam(params || ''))
    @codemarks.fetch()

  showCodemarkList: ->
    codemarksView = new App.CodemarksView
      el: $('#main_content')
      codemarks: @codemarks

    $('.content').html(codemarksView.$el)
