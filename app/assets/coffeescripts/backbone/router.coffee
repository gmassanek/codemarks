App.MainRouter = Backbone.Router.extend
  routes:
    'codemarks': 'index'
    'public': 'public'

  index: ->
    codemarksCollection = new App.Collections.Codemarks
    codemarksCollection.fetch
      success: => @successfulFetch(codemarksCollection)

  public: ->
    codemarksCollection = new App.Collections.Codemarks
      url: '/public'
    codemarksCollection.fetch
      success: => @renderPublic(codemarksCollection)

  renderPublic: (codemarks) ->
    codemarksView = new App.Views.Codemarks
      collection: codemarks
    codemarksView.render()
    $('#main_content').replaceWith(codemarksView.$el)
