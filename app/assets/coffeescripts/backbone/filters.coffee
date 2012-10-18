App.Filters = Backbone.Model.extend
  initialize: ->
    @reset()

  updateUrlWithFilters: ->
    filterParams = $.param(@data())
    if filterParams == ''
      App.router.navigate("/codemarks")
    else
      App.router.navigate("/codemarks?#{filterParams}")

  loadFromCookie: (saved_filters)->
    @attributes = @defaults()
    @setSort(saved_filters.by) if saved_filters.by
    @setTopic(saved_filters.topic_id) if saved_filters.topic_id
    @setUser(saved_filters.user) if saved_filters.user
    @setPage(saved_filters.page) if saved_filters.page

  defaults: ->
    _.extend {},
      sort: 'date'
      currentPage: 1
      topics: {}

  reset: () ->
    @attributes = @defaults()
    @set('currentPage', @defaults().currentPage)
    @trigger('change')

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
    @trigger('change')

  removeTopic: (id) ->
    delete @get('topics')[id]
    @trigger('change')

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

  hasTopic: (topic_id) ->
    $.inArray(topic_id, @topicIds()) >= 0

  setTopic: (topic) ->
    @clearTopics()
    @addTopic(topic)

  setPage: (page) ->
    @set('currentPage', page)

  data: ->
    data = {}
    data['by'] = @get('sort') if @get('sort') != @defaults().sort
    data['user'] = @get('user') if @get('user')
    data['topic_id'] = @topicId() if @topicId()
    data['page'] = @get('currentPage') if @get('currentPage')? && @get('currentPage') != 1
    data
