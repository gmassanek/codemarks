describe 'LinkCodemarkView', ->
  afterEach ->
    App.codemarks.users = new Backbone.Collection({id: 3, slug: 'gmassanek'})
    window.CURRENT_USER = null

  describe 'rerenders itself', ->
    it 'when its model changes', ->
      codemark = new App.Codemark
        resource: {}
        topics: []
        user_id: 3
      view = new App.LinkCodemarkView
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
        user_id: 3
      view = new App.LinkCodemarkView
        model: codemark
      view.render()
      expect(view.$el.hasClass('mine')).toBeTruthy()

    it 'and does not add the "mine" class if it does not belong to the current user', ->
      window.CURRENT_USER = 'somebody_else'
      codemark = new App.Codemark
        resource: {}
        topics: []
        user_id: 3
      view = new App.LinkCodemarkView
        model: codemark
      view.render()
      expect(view.$el.hasClass('mine')).toBeFalsy()

  describe 'is editable', ->
    it 'if the author is the current user', ->
      window.CURRENT_USER = 'gmassanek'
      codemark = new App.Codemark
        user_id: 3
      view = new App.LinkCodemarkView
        model: codemark
      expect(view.editable()).toBeTruthy()

    it 'unless the auther is somebody else', ->
      window.CURRENT_USER = 'somebody_else'
      codemark = new App.Codemark
        user_id: 3
      view = new App.LinkCodemarkView
        model: codemark
      expect(view.editable()).toBeFalsy()
