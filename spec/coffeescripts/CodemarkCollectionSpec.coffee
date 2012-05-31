require ['CodemarkCollection'], (CodemarkCollection) ->
  describe 'CodemarkCollection', ->
    it 'defaults url to /codemarks', ->
      coll = new CodemarkCollection
      expect(coll.url).toBe('/codemarks')

    it 'accepts a different url', ->
      coll = new CodemarkCollection('/public')
      expect(coll.url).toBe('/public')
