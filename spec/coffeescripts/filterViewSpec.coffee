describe 'filterView', ->
  beforeEach ->
    @codemarks = new App.Codemarks

  describe 'options', ->
    beforeEach ->
      @view = new App.FilterView
        type: 'topic'
        description: 'Jquery'
        dataId: 'jquery'
        codemarks: @codemarks

    it 'has a type', ->
      expect(@view.type).toBe('topic')

    it 'has a description', ->
      expect(@view.description).toBe('Jquery')

    it 'has a data-id', ->
      expect(@view.dataId).toBe('jquery')

  describe '#render', ->
    it 'has a class of "filter"', ->
      view = new App.FilterView
        codemarks: @codemarks
      view.render()
      expect(view.$el.hasClass('filter')).toBe(true)

    it 'has a class of type', ->
      view = new App.FilterView
        type: 'user'
        codemarks: @codemarks
      view.render()
      expect(view.$el.hasClass('user')).toBe(true)

    it 'sets the description to description', ->
      view = new App.FilterView
        description: 'Jquery'
        codemarks: @codemarks
      view.render()
      expect(view.$('.description').text()).toBe('Jquery')

    it 'sets the data-type to type', ->
      view = new App.FilterView
        type: 'user'
        codemarks: @codemarks
      view.render()
      expect(view.$('.remove').data('type')).toBe('user')

    it 'sets the data-id to dataId', ->
      view = new App.FilterView
        dataId: 'jquery'
        codemarks: @codemarks
      view.render()
      expect(view.$('.remove').data('id')).toBe('jquery')

    it 'does not have a .more icon', ->
      view = new App.FilterView
        type: 'topic'
        codemarks: @codemarks
      view.render()
      expect(view.$('.more').length).toBe(0)

    it 'does not have other sorts', ->
      view = new App.FilterView
        type: 'topic'
        codemarks: @codemarks
      view.render()
      expect(view.$('.other_sort').length).toBe(0)

  describe 'remove', ->
    beforeEach ->
      @view = new App.FilterView
        codemarks: @codemarks

    it 'removes a user', ->
      @view.type = 'user'
      @codemarks.filters.setUser('jbieber')
      @view.render()
      spyOn(@codemarks, 'fetch')
      @view.$('.remove').click()
      expect(@codemarks.fetch).toHaveBeenCalled()
      expect(@codemarks.filters.get('user')).toBeUndefined()

    it 'removes a topic', ->
      @view.type = 'topic'
      @view.dataId = 'rspec'
      @codemarks.filters.addTopic('rspec')
      @view.render()
      spyOn(@codemarks, 'fetch')
      @view.$('.remove').click()
      expect(@codemarks.fetch).toHaveBeenCalled()
      expect(@codemarks.filters.topicIds().length).toBe(0)

    it 'removes a search', ->
      @view.type = 'query'
      @codemarks.filters.setSearchQuery('This thing')
      @view.render()
      spyOn(@codemarks, 'fetch')
      @view.$('.remove').click()
      expect(@codemarks.fetch).toHaveBeenCalled()
      expect(@codemarks.filters.searchQuery()).toBeUndefined()

  describe 'sorts', ->
    beforeEach ->
      @view = new App.FilterView
        type: 'sort'
        dataId: 'date'
        codemarks: @codemarks

    it 'does not have a .remove link', ->
      @view.render()
      expect(@view.$('.remove').length).toBe(0)

    it 'has a .more link', ->
      @view.render()
      expect(@view.$('.more').length).toBe(1)

    it 'has the other sorts', ->
      @view.render()
      expect(@view.$('.other_sort').length).toBeGreaterThan(0)

  describe '#otherSorts', ->
    beforeEach ->
      @view = new App.FilterView
        type: 'sort'
        dataId: 'date'
        codemarks: @codemarks

    it 'is null if type != sort', ->
      @view.type = 'user'
      expect(@view.otherSorts()).toBeUndefined()

    it 'does not include the current sort', ->
      otherSorts = @view.otherSorts()
      expect(_.include(otherSorts, 'date')).toBe(false)

    it 'include the other sorts', ->
      otherSorts = @view.otherSorts()
      possibleSortsLength = @view.possibleSorts.length
      expect(otherSorts.length).toBe(possibleSortsLength - 1)

  describe 'changeSort', ->
    it 'changes sort when clicking one of the otherSorts', ->
      view = new App.FilterView
        type: 'sort'
        dataId: 'date'
        codemarks: @codemarks
      view.render()
      spyOn(@codemarks, 'fetch')
      $otherSort = $(view.$('.other_sort')[0])
      $otherSort.click()
      expect(@codemarks.fetch).toHaveBeenCalled()
      expect(@codemarks.filters.get('sort')).toBe($otherSort.data('sort'))
