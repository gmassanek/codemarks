require.config

require ['router'], (MainRouter) ->
  window.appRouter = new MainRouter
  Backbone.history.start({pushState: true})
