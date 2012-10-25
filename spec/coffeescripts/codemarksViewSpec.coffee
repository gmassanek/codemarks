describe 'CodemarksView', ->
  beforeEach ->
    @codemarks = new App.Codemarks
    @codemarksView = new App.CodemarksView
      codemarks: @codemarks

  it 'can turn the new tile into a form', ->
    @codemarksView.render()
    @codemarksView.newCodemarkTile.codemark = new App.Codemark
    @codemarksView.newCodemarkTile.trigger('turnIntoForm')
    $form = @codemarksView.$('form.codemark_form')
    expect($form.length).toBe(1)
