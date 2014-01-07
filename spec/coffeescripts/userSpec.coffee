describe 'App.User', ->
  describe '#groupFor', ->
    it 'is the group object if the user has the group', ->
      user = new App.User
        groups: [{id: 1, name: 'Group 1'}]
      expect(user.groupFor(1)).toEqual({id: 1, name: 'Group 1'})

  describe '#authorizedForGroup', ->
    it 'is true if the user has the group', ->
      user = new App.User
        groups: [{id: 1, name: 'Group 1'}]
      expect(user.authorizedForGroup(1)).toBe(true)

    it 'is true if the group is undefined', ->
      user = new App.User
        groups: [{id: 1, name: 'Group 1'}]
      expect(user.authorizedForGroup(undefined)).toBe(true)

    it 'is false if the user has the group', ->
      user = new App.User
        groups: []
      expect(user.authorizedForGroup(1)).toBe(false)
