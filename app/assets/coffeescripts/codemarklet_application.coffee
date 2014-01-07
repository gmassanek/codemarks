window.CURRENT_USER ||= null
window.CURRENT_USER_ID ||= null
window.App =
  init: ->
    $ ->
      App.current_user = new App.User(JSON.parse(window.CURRENT_USER_DATA_JSON))
      view = new App.CodemarkletView
        model: App.codemark
      view.render()
      $('body').html(view.$el)

      if analytics?
        userId = App.current_user.get('slug') || 'logged-out'
        analytics.identify userId,
          userId  : App.current_user.get('id') || 'logged-out',
          name    : App.current_user.get('name') || 'logged-out',
          username: App.current_user.get('slug') || 'logged-out'
