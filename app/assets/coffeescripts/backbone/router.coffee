define ['CodemarkCollection', 'CodemarksView'], (CodemarkCollection, CodemarksView) ->
  MainRouter = Backbone.Router.extend
    routes:
      'codemarks': 'index'
      'public': 'public'

    index: ->
      codemarksCollection = new CodemarkCollection
      codemarksCollection.fetch
        success: => @successfulFetch(codemarksCollection)

    public: ->
      codemarksCollection = new CodemarkCollection
        url: '/public'
      codemarksCollection.fetch
        success: => @renderPublic(codemarksCollection)

    renderPublic: (codemarks) ->
      codemarksView = new CodemarksView
        collection: codemarks
      codemarksView.render()
      $('#main_content').replaceWith(codemarksView.$el)

