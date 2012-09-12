App.MainRouter = Backbone.Router.extend
  routes:
    'public': 'public'
    'public?:params': 'public'
    'topics/:id': 'topic'
    ':query?:params': 'user'
    ':query': 'user'

  public: (params) ->
    App.codemarks ||= new App.Collections.Codemarks
    App.codemarks.filters.clearUsers()
    App.codemarks.filters.clearTopics()

    if params
      params = params.split('=')
      App.codemarks.filters[params[0]] = params[1]

    @showCodemarkList()
    App.codemarks.fetch()
    @setActiveNav('public')

  topic: (topicId) ->
    App.codemarks ||= new App.Collections.Codemarks
    App.codemarks.filters.clearUsers()
    App.codemarks.filters.setTopic(topicId)
    @showCodemarkList()
    App.codemarks.fetch()
    @setActiveNav('topic')

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
    @setActiveNav(selected)

  showCodemarkList: ->
    $ ->
      codemarkList = new App.Views.CodemarkList
        el: $('#main_content')
      $('.content').html(codemarkList.$el)
      App.router.setActiveSort()

  setActiveSort: ($activeSortLink) ->
    unless $activeSortLink
      activeSort = App.codemarks.filters.by
      $activeSortLink = $("li.sort a[data-by=#{activeSort}]")
    $('li.sort a').removeClass('active')
    $activeSortLink.addClass('active')

  setActiveNav: (klass) ->
    $('.nav').removeClass('active')
    setTimeout ->
      $(".nav a.#{klass}").closest('.nav').addClass('active')
    , 5

