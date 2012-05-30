define ['CodemarkCollection', 'CodemarksView'], (CodemarkCollection, CodemarksView) ->
  MainRouter = Backbone.Router.extend
    routes:
      'codemarks': 'index'

    index: ->
      codemarks = new CodemarkCollection
      codemarks.fetch
        success: => @successfulFetch(codemarks)

    successfulFetch: (codemarksCollection) ->
      codemarksView = new CodemarksView
        collection: codemarksCollection

      codemarksView.render()

      #this should go in an App View I think
      $('#main_content').replaceWith(codemarksView.$el)

