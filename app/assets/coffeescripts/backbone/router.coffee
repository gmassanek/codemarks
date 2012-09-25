App.MainRouter = Backbone.Router.extend
  routes:
    'codemarks': 'codemarks'
    'codemarks?:params': 'codemarks'

  codemarks: (params) ->
    App.codemarks ||= new App.Collections.Codemarks

    if params
      params = params.split('=')
      if params[0] == 'topic_id'
        App.codemarks.filters.setTopic(params[1])
      else if params[0] == 'user'
        App.codemarks.filters.setUser(params[1])

    @showCodemarkList()
    App.codemarks.fetch()

  topic: (topicId) ->
    App.codemarks ||= new App.Collections.Codemarks
    App.codemarks.filters.clearUsers()
    App.codemarks.filters.setTopic(topicId)
    @showCodemarkList()
    App.codemarks.fetch()

  user: (username, params) ->
    App.codemarks ||= new App.Collections.Codemarks
    App.codemarks.filters.addUser(username)
    App.codemarks.filters.clearTopics()
    if params
      params = params.split('=')
      App.codemarks.filters[params[0]] = params[1]
      selected = 'your_topic'
    else
      if CURRENT_USER? && CURRENT_USER == username
        selected = 'yours'
      else
        selected = 'theirs'

    @showCodemarkList()
    App.codemarks.fetch()

  showCodemarkList: ->
    $ ->
      codemarkList = new App.Views.CodemarkList
        el: $('#main_content')
      $('.content').html(codemarkList.$el)

      $(window).bind 'beforeunload', (e) ->
        filterData = App.codemarks.filters.dataForCookie()
        filterCookieVal = JSON.stringify(filterData)
        $.cookie('filters', filterCookieVal)
        $.cookie('filters-save-date', new Date())
        return
