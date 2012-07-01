App.MainRouter = Backbone.Router.extend
  routes:
    'public': 'public'
    ':query': 'user'

  public: ->
    codemarksCollection = new App.Collections.Codemarks
    codemarksCollection.fetch
      url: '/codemarks'
      success: => @showCodemarkList(codemarksCollection)

  user: (username) ->
    codemarksCollection = new App.Collections.Codemarks
    codemarksCollection.fetch
      url: '/codemarks'
      data:
        username: username
      success: => @showCodemarkList(codemarksCollection)

  showCodemarkList: (codemarks) ->
    codemarkList = new App.Views.CodemarkList
      collection: codemarks
    codemarkList.render()
    $('#main_content').replaceWith(codemarkList.$el)
