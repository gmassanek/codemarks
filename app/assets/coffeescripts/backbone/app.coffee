window.CURRENT_USER ||= null
window.App =
  Views: {}
  Collections: {}
  Models: {}
  init: ->
    App.router = new App.MainRouter
    App.codemarks = new App.Collections.Codemarks
    Backbone.history.start({pushState: true})
