App.MainRouter = Backbone.Router.extend
  routes:
    'public': 'public'
    ':query': 'user'

  public: ->
    App.codemarks = new App.Collections.Codemarks
    App.codemarks.flush(@showCodemarkList)

  user: (username) ->
    # should memoize here
    App.codemarks = new App.Collections.Codemarks
      username: username
    App.codemarks.flush(@showCodemarkList)

  showCodemarkList: ->
    codemarkList = new App.Views.CodemarkList
      collection: App.codemarks
    codemarkList.render()
    $('#main_content').html(codemarkList.$el)
