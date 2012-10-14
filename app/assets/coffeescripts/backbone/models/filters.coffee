App.Models.Filters = Backbone.Model.extend
  initialize: ->
    @bind 'change:user', @clearPage
    @bind 'change:topics', @clearPage
    @bind 'change', @updateUrlWithFilters
    @reset()

  updateUrlWithFilters: ->
    filterParams = $.param(@dataForCookie())
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
      user: undefined
      topics: {}

  reset: ->
    @attributes = @defaults()
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

  hasTopic: (topic_id) ->
    $.inArray(topic_id, @topicIds()) >= 0

  setTopic: (topic) ->
    @clearTopics()
    @addTopic(topic)

  setPage: (page) ->
    @set('currentPage', page)

  clearPage: ->
    @set('currentPage', @defaults().currentPage)

  data: ->
    data = {by: @get('sort')}
    data['username'] = @get('user') if @get('user')?
    data['topic_id'] = @topicId() if @topicId()
    data['page'] = @get('currentPage')
    data

  dataForCookie: ->
    data = {}
    data['by'] = @get('sort') if @get('sort') != @defaults().sort
    data['user'] = @get('user') if @get('user')
    data['topic_id'] = @topicId() if @topicId()
    data['page'] = @get('currentPage') if @get('currentPage')? && @get('currentPage') != 1
    data
