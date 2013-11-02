describe 'ControlPanelView', ->
  beforeEach ->
    @codemarks = new App.Codemarks
    App.codemarks = @codemarks
    @view = new App.ControlPanelView

  describe 'render', ->
    it 'makes one filter object if filtering by user', ->
      @codemarks.filters.setUser('jbieber')
      @view.render()
      expect(@view.$('.filter.user').length).toBe(1)

    it 'makes one filter object for each topic filter', ->
      @codemarks.filters.addTopic('rspec')
      @codemarks.filters.addTopic('jquery')
      @view.render()
      expect(@view.$('.filter.topic').length).toBe(2)

    it 'makes a filter object for a search filter', ->
      @codemarks.filters.setSearchQuery('This thing')
      @view.render()
      expect(@view.$('.filter.query').length).toBe(1)

    it 'makes a filter object for the sort', ->
      @view.render()
      expect(@view.$('.filter.sort').length).toBe(1)

    it 'makes a search bar', ->
      @view.render()
      expect(@view.$('input#search').length).toBe(1)

  describe 'search', ->
    beforeEach ->
      @view.render()
      spyOn(@codemarks, 'fetch')

    it 'fetches codemarks', ->
      @view.$('#search').val('javascript')
      @view.search()
      expect(@codemarks.fetch).toHaveBeenCalled()

    it 'sets a search filter', ->
      @view.$('#search').val('foobar')
      @view.search()
      expect(@codemarks.filters.searchQuery()).toBe('foobar')

    it 'sets a filter topic if one is picked', ->
      App.topics.add({slug: 'test-topic'})
      @view.$('#search').val('test-topic')
      @view.search()
      expect(@codemarks.filters.hasTopic('test-topic')).toBe(true)

    it 'does not search if nothing has been entered', ->
      @view.search()
      expect(@codemarks.fetch).not.toHaveBeenCalled()
