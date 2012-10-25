describe 'NewCodemarkTileView', ->
  beforeEach ->
    @tile = new App.NewCodemarkTileView

  it 'looks like a tile', ->
    @tile.render()
    expect(@tile.$el.hasClass('codemark')).toBeTruthy()

  describe 'shows a url form', ->
    it 'has a form in the new_link section', ->
      @tile.render()
      @tile.showUrlForm()
      expect(@tile.$('.add_link form').length).toBe(1)

  describe 'creates a new codemark', ->
    it 'for a url', ->
      codemark = @tile.createCodemarkFor('some_url')
      expect(codemark.get('resource').url).toBe('some_url')
      expect(codemark.get('resource_type')).toBe('LinkRecord')

    it 'is undefined if there is no url', ->
      codemark = @tile.createCodemarkFor()
      expect(codemark).toBeUndefined()

  describe 'turns into a new codemark form', ->
    it 'by asking to be', ->
      triggered = false
      @tile.bind 'turnIntoForm', -> triggered = true

      @tile.turnIntoLinkForm()
      expect(triggered).toBeTruthy()
