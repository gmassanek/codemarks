describe 'Tile View', ->
  beforeEach ->
    @codemark = new App.Codemark
      id: 10
      resource: {}
    @view = new App.TileView
      model: @codemark

  describe 'renders', ->
    it 'a %section.tile', ->
      renderSpy = spyOn(App.CodemarkView.prototype, 'render')
      @view.render()
      expect(@view.$el.hasClass('tile')).toBeTruthy()
      expect(@view.$el.prop('tagName')).toBe('SECTION')

    it 'a CodemarkView if the codemark exists', ->
      spyOn(@view, 'renderCodemarkView')
      @view.render()
      expect(@view.renderCodemarkView).toHaveBeenCalled()

  describe 'always has a codemark model', ->
    it 'makes a new one if not given one', ->
      view = new App.TileView
      expect(view.model).toBeDefined()

    it 'uses an existing one', ->
      renderSpy = spyOn(App.CodemarkView.prototype, 'render')
      @view.render()
      expect(@view.model).toBe(@codemark)

  describe 'renderCodemarkView', ->
    it 'returns if the model is new', ->
      @view.model.new = -> true
      @view.renderCodemarkView()
      expect(@view.view).toBeUndefined()

    it 'fills the tile with a view', ->
      renderSpy = spyOn(App.CodemarkView.prototype, 'render')
      @view.renderCodemarkView()
      expect(@view.view).toBeDefined()

    it 'renders a codemarkView', ->
      renderSpy = spyOn(App.CodemarkView.prototype, 'render')
      @view.renderCodemarkView()
      expect(renderSpy).toHaveBeenCalled()
