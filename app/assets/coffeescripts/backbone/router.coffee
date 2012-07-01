App.MainRouter = Backbone.Router.extend
  routes:
    'public': 'public'

  public: ->
    codemarksCollection = new App.Collections.Codemarks
      url: '/public'
    codemarksCollection.fetch
      success: => @showCodemarkList(codemarksCollection)

  showCodemarkList: (codemarks) ->
    codemarkList = new App.Views.CodemarkList
      collection: codemarks
    codemarkList.render()
    $('#main_content').replaceWith(codemarkList.$el)
