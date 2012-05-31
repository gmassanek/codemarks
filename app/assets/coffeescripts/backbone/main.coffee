require.config
  baseUrl: '/assets/backbone'

require ['router'], (MainRouter) ->
  window.appRouter = new MainRouter
  Backbone.history.start({pushState: true})
