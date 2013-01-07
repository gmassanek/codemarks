window.CURRENT_USER ||= null
window.App =
  init: ->
    $ ->
      view = new App.CodemarkletView
        model: App.codemark
      view.render()
      $('body').html(view.$el)
