describe 'CodemarkFormView', ->
  describe 'renders', ->
    it 'selects topics in the model', ->
      codemark = new App.Codemark
        topics: [{id: 1}]
      view = new App.CodemarkFormView
        model: codemark
      view.render()
      expect(view.$(".topics option:selected").length).toBe(1)
