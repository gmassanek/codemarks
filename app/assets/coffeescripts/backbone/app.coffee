window.App =
  Views: {}
  Collections: {}
  Models: {}
  init: ->
    window.appRouter = new App.MainRouter
    Backbone.history.start({pushState: true})
