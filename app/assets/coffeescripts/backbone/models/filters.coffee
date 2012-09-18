App.Models.Filters = Backbone.Model.extend
  initialize: ->
    @attributes = @defaults

  defaults:
    sort: 'date'
    users: {}
    topics: {}

  setSort: (sortType) ->
    @set('sort', sortType)

  addUser: (username) ->
    @get('users')[username] = true

  removeUser: (username) ->
    delete @get('users')[username]

  username: ->
    for key, _val of @get('users')
      return key

  usernames: ->
    keys = []
    for key, _val of @get('users')
      keys.push(key)
    keys

  hasUser: (username) ->
    $.inArray(username, @usernames()) >= 0

  setUser: (user) ->
    @clearTopics()
    @addUser(user)

  addTopic: (id) ->
    @get('topics')[id] = true

  removeTopic: (id) ->
    delete @get('topics')[id]

  topicIds: ->
    keys = []
    for key, _val of @get('topics')
      keys.push(key)
    keys

  clearUsers: ->
    for key, _val of @get('users')
      delete @get('users')[key]

  clearTopics: ->
    for key, _val of @get('topics')
      delete @get('topics')[key]

  topicId: ->
    for key, _val of @get('topics')
      return key

  hasTopic: (username) ->
    $.inArray(username, @topicIds()) >= 0

  setTopic: (topic) ->
    @clearTopics()
    @addTopic(topic)

  data: ->
    data = {by: @get('sort')}
    data['username'] = @username() if @username()
    data['topic_id'] = @topicId() if @topicId()
    data
