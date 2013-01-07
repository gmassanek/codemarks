window.CURRENT_USER ||= null
window.App =
  init: ->
    $.ajaxSetup
      cache: false

    App.router = new App.MainRouter
    Backbone.history.start({pushState: true})
