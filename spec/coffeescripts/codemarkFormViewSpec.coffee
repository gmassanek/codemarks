describe 'LinkRecordFormView', ->
  describe 'renders', ->
    it 'selects topics in the model', ->
      codemark = new App.Codemark
        topics: [{ id: 1, slug: 'hello' }, { id: 2, slug: 'github'}]
        resource: { id: 1 }
      view = new App.LinkRecordFormView
        model: codemark
      view.render()
      expect(view.$("input.topics").val()).toBe('hello,github')

  describe 'fetches data for a new codemark', ->
    it 'if it is a new resource with a url', ->
      codemark = new App.Codemark
        resource_type: 'LinkRecord'
        resource:
          url: 'http://www.google.com'
      view = new App.LinkRecordFormView
        model: codemark
      spyOn(view, 'fetchFullFormFor')
      view.render()
      expect(view.fetchFullFormFor).toHaveBeenCalled()
