window.CURRENT_USER ||= null
window.App =
  Views: {}
  init: ->
    App.router = new App.MainRouter
    App.codemarks = new App.Codemarks
    Backbone.history.start({pushState: true})
