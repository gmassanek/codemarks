describe 'Router', ->
  router = new App.MainRouter

  it 'routes home to index', ->
    expect(router.routes['codemarks']).toEqual('index')

  it 'routes public to index', ->
    expect(router.routes['public']).toEqual('public')
