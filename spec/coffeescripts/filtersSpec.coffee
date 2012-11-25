describe 'Codemark Filters', ->

  beforeEach ->
    @addMatchers
      toBeEqualToObject: (expected) ->
        _.isEqual @actual, expected

    @filters = new App.Filters

  describe 'has a currentPage', ->
    it 'that is 1 by default', ->
      expect(@filters.get('currentPage')).toBe(1)

    it 'that can be set', ->
      @filters.setPage(8)
      expect(@filters.get('currentPage')).toBe(8)

  describe 'has a user', ->
    it 'that is empty by default', ->
      expect(@filters.get('user')).toBeEqualToObject(undefined)

    it 'that can be set', ->
      @filters.setUser('gmassanek')
      expect(@filters.hasUser('gmassanek')).toBeTruthy()

    it 'that can be deleted', ->
      @filters.addUser('gmassanek')
      @filters.removeUser('gmassanek')
      expect(@filters.hasUser('gmassanek')).toBeFalsy()

    it 'that can be cleared', ->
      @filters.addUser('gmassanek')
      @filters.clearUsers()
      expect(@filters.hasUser('gmassanek')).toBeFalsy()

  describe 'have topics', ->
    it 'in a list', ->
      expect(@filters.get('topics')).toBeDefined()

    it 'that are empty by default', ->
      expect(@filters.get('topics')).toBeEqualToObject({})

    it 'that can be added to', ->
      @filters.addTopic(3)
      expect(@filters.get('topics')[3]).toBeTruthy()

    it 'that can be deleted', ->
      @filters.addTopic(3)
      @filters.removeTopic(3)
      expect(@filters.get('topics')[3]).toBeUndefined()

    it 'that can be detected', ->
      @filters.addTopic('rspec')
      expect(@filters.hasTopic('rspec')).toBe(true)

    it 'that can be set', ->
      @filters.setTopic('rspec')
      expect(@filters.get('topics')).toBeEqualToObject({'rspec':true})

  describe 'has a sort', ->
    it 'that is "date" by default', ->
      expect(@filters.get('sort')).toBe('date')

    it 'that can be changed', ->
      expect(@filters.setSort('count'))
      expect(@filters.get('sort')).toBe('count')

  describe 'has a search query', ->
    it 'that is undefined by default', ->
      expect(@filters.searchQuery()).toBeUndefined()

    it 'that can be changed', ->
      expect(@filters.setSearchQuery('javascript'))
      expect(@filters.searchQuery()).toBe('javascript')

  describe 'reset', ->
    it 're-establishes the defaults', ->
      @filters.setUser('gmassanek')
      @filters.addTopic('rspec')
      @filters.setPage(8)
      @filters.setSort('hooplah')
      @filters.reset()
      expect(@filters.attributes).toBeEqualToObject(@filters.defaults())
        
  describe 'can turn into query data',  ->
    it 'nicely', ->
      @filters.setUser('gmassanek')
      @filters.addTopic('rspec')
      @filters.setPage(8)
      @filters.setSort('visits')
      @filters.setSearchQuery('javascript')
      expect(@filters.data()).toBeEqualToObject
        by: 'visits'
        user: 'gmassanek'
        topic_id: 'rspec'
        page: 8
        query: 'javascript'
