window.CURRENT_USER ||= null
window.App =
  init: ->
    $.ajaxSetup
      cache: false

    App.router = new App.MainRouter
    App.codemarks = new App.Codemarks
    Backbone.history.start({pushState: true})
