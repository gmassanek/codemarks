describe 'CodemarkCollection', ->
  it 'defaults url to /codemarks', ->
    coll = new App.Collections.Codemarks
    expect(coll.url).toBe('/codemarks')

  it 'accepts a different url', ->
    coll = new App.Collections.Codemarks('/public')
    expect(coll.url).toBe('/public')
