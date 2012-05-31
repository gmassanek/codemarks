require ['router', 'CodemarkCollection'], (MainRouter, CodemarkCollection) ->
  describe 'Router', ->
    router = new MainRouter

    it 'routes home to index', ->
      expect(router.routes['codemarks']).toEqual('index')

    it 'routes public to index', ->
      expect(router.routes['public']).toEqual('public')
