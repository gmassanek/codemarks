describe 'Codemark Filters', ->

  beforeEach ->
    @addMatchers
      toBeEqualToObject: (expected) ->
        _.isEqual @actual, expected

    @filters = new App.Models.Filters

  describe 'have users', ->
    it 'in a list', ->
      expect(@filters.get('users')).toBeDefined()

    it 'that are empty by default', ->
      expect(@filters.get('users')).toBeEqualToObject({})

    it 'that can be added to', ->
      @filters.addUser('gmassanek')
      expect(@filters.get('users')['gmassanek']).toBeTruthy()

    it 'that can be deleted', ->
      @filters.addUser('gmassanek')
      @filters.removeUser('gmassanek')
      expect(@filters.get('users')['gmassanek']).toBeUndefined()

    it 'that can be detected', ->
      @filters.addUser('gmassanek')
      expect(@filters.hasUser('gmassanek')).toBe(true)

    it 'that really are just usernames', ->
      @filters.clearUsers()
      @filters.addUser('gmassanek')
      usernames = @filters.usernames()
      expect(usernames.length).toBe(1)
      expect(usernames[0]).toBe('gmassanek')

    it 'that can be set', ->
      @filters.setUser('gmassanek')
      expect(@filters.get('users')).toBeEqualToObject({'gmassanek':true})

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

    it 'that can be change', ->
      expect(@filters.setSort('count'))
      expect(@filters.get('sort')).toBe('count')
        
  describe 'can turn into query data',  ->
    it 'just does', ->
