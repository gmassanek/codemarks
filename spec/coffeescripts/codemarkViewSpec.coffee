describe 'CodemarkView', ->
  beforeEach ->
    @codemark = new App.Codemark
      author: {slug: 'gmassanek'}

    @view = new App.CodemarkView
      model: @codemark

  describe 'navigateToAuthor', ->
    it 'triggers an update', ->
      triggerSpy = spyOn(App.vent, 'trigger')
      @view.navigateToAuthor()
      expect(triggerSpy).toHaveBeenCalled()

    it 'adds that user', ->
      @view.navigateToAuthor()
      expect(App.codemarks.filters.get('user')).toBe('gmassanek')

    it 'does nothing if that user is already added', ->
      App.codemarks.filters.setUser('gmassanek')
      triggerSpy = spyOn(App.vent, 'trigger')
      @view.navigateToAuthor()
      expect(triggerSpy).not.toHaveBeenCalled()
