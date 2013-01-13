describe 'CodemarkCollection', ->
  beforeEach ->
    @codemarks = new App.Codemarks

  it 'defaults url to /codemarks', ->
    expect(@codemarks.url).toBe('/codemarks')
