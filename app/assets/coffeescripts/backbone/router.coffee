App.MainRouter = Backbone.Router.extend
  routes:
    'public': 'public'
    'topics/:id': 'topic'
    ':query?:params': 'user'
    ':query': 'user'

  public: ->
    App.codemarks ||= new App.Collections.Codemarks
    delete App.codemarks.filters.username
    delete App.codemarks.filters.topic_id
    App.codemarks.flush(@showCodemarkList)
    @setActiveNav('public')

  topic: (params) ->
    App.codemarks ||= new App.Collections.Codemarks
    delete App.codemarks.filters.username
    App.codemarks.filters.topic_id = params
    App.codemarks.flush(@showCodemarkList)
    @setActiveNav('topic')

  user: (username, params) ->
    App.codemarks ||= new App.Collections.Codemarks
    App.codemarks.filters.username = username
    delete App.codemarks.filters.topic_id
    if params
      params = params.split('=')
      App.codemarks.filters[params[0]] = params[1]
      selected = 'your_topic'
    else
      if CURRENT_USER?
        selected = 'yours'
      else
        selected = 'theirs'

    App.codemarks.flush(@showCodemarkList)
    @setActiveNav(selected)

  showCodemarkList: ->
    codemarkList = new App.Views.CodemarkList
      collection: App.codemarks
    codemarkList.render()
    $('#main_content').html(codemarkList.$el)
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

