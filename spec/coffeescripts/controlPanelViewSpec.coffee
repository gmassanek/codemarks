describe 'ControlPanelView', ->
  beforeEach ->
    @codemarks = new App.Codemarks
    @view = new App.ControlPanelView
      codemarks: @codemarks

  describe 'render', ->
    it 'makes one filter object if filtering by user', ->
      @codemarks.filters.setUser('jbieber')
      @view.render()
      expect(@view.$el.find('.filter a[data-type=user]').length).toBe(1)

    it 'makes one filter object for each topic filter', ->
      @codemarks.filters.addTopic('rspec')
      @codemarks.filters.addTopic('jquery')
      @view.render()
      expect(@view.$el.find('.filter a[data-type=topic]').length).toBe(2)

    it 'makes a search bar', ->
      @view.render()
      expect(@view.$el.find('input#search').length).toBe(1)

  describe 'removeFilter', ->
    it 'removes a user', ->
      @codemarks.filters.setUser('jbieber')
      @view.render()
      spyOn(@codemarks, 'fetch')
      @view.$el.find('.remove').click()
      expect(@codemarks.fetch).toHaveBeenCalled()
      expect(@codemarks.filters.get('user')).toBeUndefined()

    it 'removes a topic', ->
      @codemarks.filters.addTopic('rspec')
      @view.render()
      spyOn(@codemarks, 'fetch')
      @view.$el.find('.remove').click()
      expect(@codemarks.fetch).toHaveBeenCalled()
      expect(@codemarks.filters.topicIds().length).toBe(0)
