describe 'CodemarkView', ->
  afterEach ->
    delete window.CURRENT_USER

  describe "renders it's own HTML", ->
    it 'and adds the "mine" class if it belongs to the current user', ->
      window.CURRENT_USER = 'gmassanek'
      codemark = new App.Codemark
        resource: {}
        topics: []
        author: { slug: 'gmassanek' }
      view = new App.CodemarkView
        model: codemark
      view.render()
      expect(view.$el.hasClass('mine')).toBeTruthy()

    it 'and does not add the "mine" class if it does not belong to the current user', ->
      window.CURRENT_USER = 'somebody_else'
      codemark = new App.Codemark
        resource: {}
        topics: []
        author: { slug: 'gmassanek' }
      view = new App.CodemarkView
        model: codemark
      view.render()
      expect(view.$el.hasClass('mine')).toBeFalsy()
