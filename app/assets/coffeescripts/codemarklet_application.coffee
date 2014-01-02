window.CURRENT_USER ||= null
window.CURRENT_USER_ID ||= null
window.App =
  init: ->
    $ ->
      App.current_user = new Backbone.Model(JSON.parse(window.CURRENT_USER_DATA_JSON))
      view = new App.CodemarkletView
        model: App.codemark
      view.render()
      $('body').html(view.$el)
