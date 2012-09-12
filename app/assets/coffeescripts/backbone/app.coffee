window.CURRENT_USER ||= null
window.App =
  Views: {}
  Collections: {}
  Models: {}
  init: ->
    App.router = new App.MainRouter
    Backbone.history.start({pushState: true})
