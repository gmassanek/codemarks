window.CURRENT_USER ||= null
window.App =
  Views: {}
  Collections: {}
  Models: {}
  init: ->
    $ ->
      App.router = new App.MainRouter
      App.codemarks = new App.Collections.Codemarks
      if CURRENT_USER
        App.header = new App.Views.Header
        App.header.render()
      Backbone.history.start({pushState: true})
