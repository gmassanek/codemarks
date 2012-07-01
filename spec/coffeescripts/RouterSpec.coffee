describe 'Router', ->
  router = new App.MainRouter

  describe 'routes pages like', ->
    it 'public to Codemarks#public', ->
      expect(router.routes['public']).toEqual('public')
    it 'passes showCodemarkList to succes? - Should you test what function you pass?', ->

  describe '#showCodemarkList', ->
    it 'has better tests than the next to that know all about implementation', ->
    it 'renders the CodemarkList view with the incoming codemarks', ->
    it 'appends that to the dom', ->

