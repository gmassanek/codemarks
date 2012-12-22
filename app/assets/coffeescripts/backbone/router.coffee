App.MainRouter = Backbone.Router.extend
  routes:
    '': 'codemarks'
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

    tabsNav = new App.TabsView
      el: $('nav ul.tabs')
      codemarks: @codemarks

    $('.content').html(codemarksView.$el)
