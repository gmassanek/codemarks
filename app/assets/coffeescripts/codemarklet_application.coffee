window.CURRENT_USER ||= null
window.CURRENT_USER_ID ||= null
window.App =
  init: ->
    $ ->
      view = new App.CodemarkletView
        model: App.codemark
      view.render()
      $('body').html(view.$el)
