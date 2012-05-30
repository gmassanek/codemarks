define ['Codemark', 'CodemarksView'], (Codemark, CodemarksView) ->
  CodemarkCollection = Backbone.Collection.extend
    model: Codemark
    url: '/codemarks'

    initialize: ->
      @fetch
        success: => @successfulFetch()

    successfulFetch: ->
      codemarksView = new CodemarksView
        collection: @

      codemarksView.render()

      #this should go in an App View I think
      $('#main_content').replaceWith(codemarksView.$el)

