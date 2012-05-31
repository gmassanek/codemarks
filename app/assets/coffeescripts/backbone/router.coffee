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
        success: => @successfulFetch(codemarksCollection)

    successfulFetch: (codemarksCollection) ->
      codemarksView = new CodemarksView
        collection: codemarksCollection

      codemarksView.render()

      #this should go in an App View I think
      $('#main_content').replaceWith(codemarksView.$el)

