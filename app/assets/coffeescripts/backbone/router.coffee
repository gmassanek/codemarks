App.MainRouter = Backbone.Router.extend
  routes:
    'public': 'public'
    ':query': 'user'

  public: ->
    App.codemarks ||= new App.Collections.Codemarks
    delete App.codemarks.filters.username
    App.codemarks.flush(@showCodemarkList)

  user: (username) ->
    App.codemarks ||= new App.Collections.Codemarks
    App.codemarks.filters.username = username
    App.codemarks.flush(@showCodemarkList)

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

