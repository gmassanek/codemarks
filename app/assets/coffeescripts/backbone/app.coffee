window.CURRENT_USER ||= null
window.CURRENT_USER_ID ||= null
window.App =
  init: ->
    $.ajaxSetup
      cache: false

    App.router = new App.MainRouter
    App.router.bind 'all', -> App.router.trackPageview()
    App.vent = _.extend({}, Backbone.Events)
    App.vent.bind('updateCodemarkRequest', => App.router.updateUrlWithFilters())
    App.socketListener = new App.SocketListener() if App.SocketListener?
    Backbone.history.start
      pushState: true
