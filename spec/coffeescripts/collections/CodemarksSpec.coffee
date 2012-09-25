describe 'CodemarkCollection', ->
  beforeEach ->
    @codemarks = new App.Collections.Codemarks

  it 'defaults url to /codemarks', ->
    expect(@codemarks.url).toBe('/codemarks')
