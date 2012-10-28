describe 'CodemarkFormView', ->
  describe 'renders', ->
    it 'selects topics in the model', ->
      codemark = new App.Codemark
        topics: [{ id: 1 }]
        resource: { id: 1 }
      view = new App.CodemarkFormView
        model: codemark
      view.render()
      expect(view.$(".topics option:selected").length).toBe(1)

  describe 'fetches data for a new codemark', ->
    it 'if it is a new resource with a url', ->
      codemark = new App.Codemark
        resourceType: 'LinkRecord'
        resource:
          url: 'http://www.google.com'
      view = new App.CodemarkFormView
        model: codemark
      spyOn(view, 'fetchFullFormFor')
      view.render()
      expect(view.fetchFullFormFor).toHaveBeenCalled()
