require ['router'], (MainRouter) ->
  describe 'Router', ->
    router = new MainRouter
    it 'routes home to index', ->
      expect(router.routes['codemarks']).toEqual('index')
