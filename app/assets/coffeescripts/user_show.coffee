$ ->
  codemarks = new App.Codemarks
  codemarks.filters.setUser(CURRENT_USER)
  App.topics = new App.Topics
  App.topics.fetch()
  codemarksView = new App.CodemarksView
    el: $('.content')
    codemarks: codemarks

  codemarks.fetch()
