describe 'LinkRecordCodemarkView', ->
  afterEach ->
    window.CURRENT_USER = null

  describe 'rerenders itself', ->
    it 'when its model changes', ->
      codemark = new App.Codemark
        resource: {}
        topics: []
        author: { slug: 'gmassanek' }
      view = new App.LinkRecordCodemarkView
        model: codemark
      spyOn(view, 'render')
      codemark.trigger('change')
      expect(view.render).toHaveBeenCalled()

  describe "renders it's own HTML", ->
    it 'and adds the "mine" class if it belongs to the current user', ->
      window.CURRENT_USER = 'gmassanek'
      codemark = new App.Codemark
        resource: {}
        topics: []
        author: { slug: 'gmassanek' }
      view = new App.LinkRecordCodemarkView
        model: codemark
      view.render()
      expect(view.$el.hasClass('mine')).toBeTruthy()

    it 'and does not add the "mine" class if it does not belong to the current user', ->
      window.CURRENT_USER = 'somebody_else'
      codemark = new App.Codemark
        resource: {}
        topics: []
        author: { slug: 'gmassanek' }
      view = new App.LinkRecordCodemarkView
        model: codemark
      view.render()
      expect(view.$el.hasClass('mine')).toBeFalsy()

  describe 'is editable', ->
    it 'if the author is the current user', ->
      window.CURRENT_USER = 'gmassanek'
      codemark = new App.Codemark
        author: { slug: 'gmassanek' }
      view = new App.LinkRecordCodemarkView
        model: codemark
      expect(view.editable()).toBeTruthy()

    it 'unless the auther is somebody else', ->
      window.CURRENT_USER = 'somebody_else'
      codemark = new App.Codemark
        author: { slug: 'gmassanek' }
      view = new App.LinkRecordCodemarkView
        model: codemark
      expect(view.editable()).toBeFalsy()
