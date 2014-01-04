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
    App.current_user = new Backbone.Model(JSON.parse(window.CURRENT_USER_DATA_JSON))
    Backbone.history.start
      pushState: true

    if analytics?
      userId = App.current_user.get('id') || 'logged-out'
      analytics.identify userId,
        userId  : App.current_user.get('id') || 'logged-out',
        name    : App.current_user.get('name') || 'logged-out',
        username: App.current_user.get('slug') || 'logged-out'
