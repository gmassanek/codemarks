describe 'CodemarksView', ->
  beforeEach ->
    @codemarks = new App.Codemarks
      topics: []
      author: {'gmassanek'}
      resource: {id: 1}
    @codemarksView = new App.CodemarksView
      codemarks: @codemarks
