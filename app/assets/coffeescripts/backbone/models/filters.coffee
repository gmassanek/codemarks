App.Models.Filters = Backbone.Model.extend
  initialize: ->
    saved_filters = JSON.parse($.cookie('filters'))
    @attributes = @defaults()
    if saved_filters
      @setSort(saved_filters.sort)
      @attributes.topics = saved_filters.topics
      if saved_filters.user
        @setUser(saved_filters.user)
      if saved_filters.currentPage
        @setPage(saved_filters.currentPage)

    $.cookie('filters', null)

  defaults: ->
    _.extend {},
      sort: 'date'
      user: undefined
      topics: {}

  reset: ->
    @clearUsers()
    @clearTopics()
    @set('sort', @defaults().sort)

  setSort: (sortType) ->
    @set('sort', sortType)

  setUser: (username) ->
    @set('user', username)

  hasUser: (username) ->
    @get('user') == username

  addUser: (username) ->
    @setUser(username)

  removeUser: ->
    @setUser(undefined)

  clearUsers: ->
    @removeUser()

  addTopic: (id) ->
    @get('topics')[id] = true
    @trigger('change:topics')

  removeTopic: (id) ->
    delete @get('topics')[id]
    @trigger('change:topics')

  topicIds: ->
    keys = []
    for key, _val of @get('topics')
      keys.push(key)
    keys

  clearTopics: ->
    @set('topics', @defaults().topics)

  topicId: ->
    for key, _val of @get('topics')
      return key

  hasTopic: (username) ->
    $.inArray(username, @topicIds()) >= 0

  setTopic: (topic) ->
    @clearTopics()
    @addTopic(topic)

  setPage: (page) ->
    @set('currentPage', page)

  clearPage: ->
    @set('currentPage', undefined)

  data: ->
    data = {by: @get('sort')}
    data['username'] = @get('user') if @get('user')
    data['topic_id'] = @topicId() if @topicId()
    data['page'] = @get('currentPage') if @get('currentPage')
    data
