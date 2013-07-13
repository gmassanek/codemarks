describe 'Tile View', ->
  beforeEach ->
    @codemark = new App.Codemark
      id: 10
      author: { slug: 'gmassanek' }
      resource_type: 'LinkRecord'
      resource: {}
    @view = new App.TileView
      model: @codemark

  describe 'has options', ->
    it 'can be the addCodemark tile', ->
      view = new App.TileView
        add: true
      expect(view.isTheAddCodemarkTile).toBeTruthy()

  describe 'renders', ->
    it 'a %section.tile', ->
      renderSpy = spyOn(App.LinkRecordCodemarkView.prototype, 'render')
      @view.render()
      expect(@view.$el.hasClass('tile')).toBeTruthy()
      expect(@view.$el.prop('tagName')).toBe('SECTION')

    it 'a LinkRecordCodemarkView if the codemark exists', ->
      spyOn(@view, 'renderCodemarkView')
      @view.render()
      expect(@view.renderCodemarkView).toHaveBeenCalled()

    it 'an AddCodemarkView if it isTheAddCodemarkTile', ->
      @view.isTheAddCodemarkTile = true
      spyOn(@view, 'renderAddCodemarkView')
      @view.render()
      expect(@view.renderAddCodemarkView).toHaveBeenCalled()

  describe 'always has a codemark model', ->
    it 'makes a new one if not given one', ->
      view = new App.TileView
      expect(view.model).toBeDefined()

    it 'uses an existing one', ->
      renderSpy = spyOn(App.LinkRecordCodemarkView.prototype, 'render')
      @view.render()
      expect(@view.model).toBe(@codemark)

  describe 'renderCodemarkView', ->
    it 'does nothing if it isTheAddCodemarkTile', ->
      @view.isTheAddCodemarkTile = true
      @view.renderCodemarkView()
      expect(@view.view).toBeUndefined()

    it 'fills the tile with a view', ->
      renderSpy = spyOn(App.LinkRecordCodemarkView.prototype, 'render')
      @view.renderCodemarkView()
      expect(@view.view).toBeDefined()

    it 'renders a codemarkView', ->
      renderSpy = spyOn(App.LinkRecordCodemarkView.prototype, 'render')
      @view.renderCodemarkView()
      expect(renderSpy).toHaveBeenCalled()

    it 'inserts and binds to the view', ->
      renderSpy = spyOn(App.LinkRecordCodemarkView.prototype, 'render')
      insertSpy = spyOn(@view, 'replaceElWithView')
      bindSpy = spyOn(@view, 'bindToView')
      @view.renderCodemarkView()
      expect(insertSpy).toHaveBeenCalled()
      expect(bindSpy).toHaveBeenCalled()

  describe 'renderAddCodemarkView', ->
    beforeEach ->
      @view.isTheAddCodemarkTile = true

    it 'does nothing if it isTheAddCodemarkTile is false', ->
      @view.isTheAddCodemarkTile = false
      @view.renderAddCodemarkView()
      expect(@view.view).toBeUndefined()

    it 'fills the tile with a view', ->
      renderSpy = spyOn(App.LinkRecordCodemarkView.prototype, 'render')
      @view.renderAddCodemarkView()
      expect(@view.view).toBeDefined()

    it 'renders an AddCodemarkView', ->
      renderSpy = spyOn(App.AddCodemarkView.prototype, 'render')
      @view.renderAddCodemarkView()
      expect(renderSpy).toHaveBeenCalled()

    it 'inserts and binds to the view', ->
      insertSpy = spyOn(@view, 'replaceElWithView')
      bindSpy = spyOn(@view, 'bindToView')
      @view.renderAddCodemarkView()
      expect(insertSpy).toHaveBeenCalled()
      expect(bindSpy).toHaveBeenCalled()

  describe 'turnViewIntoForm', ->
    beforeEach ->
      @newCodemark = new App.Codemark
        resource:
          url: 'http://www.google.com'
        resource_type: 'LinkRecord'
      @addView = new App.AddCodemarkView
        model: @newCodemark
      @view.view = @addView

    it 'replaces the tile with a view', ->
      renderSpy = spyOn(App.LinkRecordFormView.prototype, 'render')
      @view.turnViewIntoForm()
      expect(@view.view).not.toBe(@addView)

    it 'renders a codemarkFormView', ->
      renderSpy = spyOn(App.LinkRecordFormView.prototype, 'render')
      @view.turnViewIntoForm()
      expect(renderSpy).toHaveBeenCalled()

    it 'uses the model from the current view', ->
      renderSpy = spyOn(App.LinkRecordFormView.prototype, 'render')
      @view.turnViewIntoForm()
      expect(@view.model).toBe(@newCodemark)

  describe 'listens to the view it created', ->
    it 'for when it wants to turn into a form', ->
      codemarkView = new App.LinkRecordCodemarkView
        model: @codemark
      @view.view = codemarkView
      @view.bindToView()
      spyOn(@view, 'turnViewIntoForm')
      codemarkView.trigger('turnIntoForm')
      expect(@view.turnViewIntoForm).toHaveBeenCalled()

    it 'for when it wants to cancel and just rerenders', ->
      codemarkView = new App.LinkRecordCodemarkView
        model: @codemark
      @view.view = codemarkView
      @view.bindToView()
      spyOn(@view, 'render')
      codemarkView.trigger('cancel')
      expect(@view.render).toHaveBeenCalled()

    it 'for when it updated its codemark', ->
      codemarkFormView = new App.CodemarkFormView
      @view.view = codemarkFormView
      @view.bindToView()
      spyOn(@view, 'render')
      codemarkFormView.trigger('updated')
      expect(@view.render).toHaveBeenCalled()

    it 'for when it has created a new codemark', ->
      codemarkFormView = new App.CodemarkFormView
      @view.view = codemarkFormView
      @view.bindToView()
      spyOn(@view, 'codemarkCreated')
      codemarkFormView.trigger('created')
      expect(@view.codemarkCreated).toHaveBeenCalled()

    it 'for when it has been removed', ->
      codemarkView = new App.LinkRecordCodemarkView
        model: @codemark
      @view.view = codemarkView
      @view.bindToView()
      spyOn(@view, 'remove')
      codemarkView.trigger('delete')
      expect(@view.remove).toHaveBeenCalled()

    it 'for when it is being copied to a new user', ->
      codemarkView = new App.LinkRecordCodemarkView
        model: @codemark
      @view.view = codemarkView
      @view.bindToView()
      spyOn(@view, 'copyForNewUser')
      codemarkView.trigger('createCopy')
      expect(@view.copyForNewUser).toHaveBeenCalled()

  describe 'handles a codemark being created', ->
    it 'by rerendering', ->
      spyOn(@view, 'render')
      @view.codemarkCreated()
      expect(@view.render).toHaveBeenCalled()

    it 'adds the codemark to the codemarks collection', ->
      spyOn(@view, 'render')
      createdSpy = jasmine.createSpy('codemarkCreated')
      App.codemarks.bind 'add', createdSpy
      @view.codemarkCreated()
      expect(createdSpy).toHaveBeenCalled()

  describe 'creates a codemark for a new user', ->
    it 'remembers the model to copy', ->
      codemarkView = new App.LinkRecordCodemarkView
        model: @codemark
      spyOn(@view, 'turnViewIntoForm')
      @view.view = codemarkView
      @view.copyForNewUser()
      expect(@view.modelToCopy).toBe(@codemark)

    it 'removes the user and id of the existing model', ->
      codemarkView = new App.LinkRecordCodemarkView
        model: @codemark
      spyOn(@view, 'turnViewIntoForm')
      @view.view = codemarkView
      @view.copyForNewUser()
      expect(@view.view.model.get('id')).toBeUndefined()
      expect(@view.view.model.get('author')).toBeUndefined()
      expect(@view.view.model.get('user_id')).toBeUndefined()

    it 'turns into a form', ->
      codemarkView = new App.LinkRecordCodemarkView
        model: @codemark
      @view.view = codemarkView
      spyOn(@view, 'turnViewIntoForm')
      @view.copyForNewUser()
      expect(@view.turnViewIntoForm).toHaveBeenCalled()

