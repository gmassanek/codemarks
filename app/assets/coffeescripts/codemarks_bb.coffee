window.CodemarksBB =
  bootstrap: ->
    MainRouter = Backbone.Router.extend
      routes:
        'public': 'public'

      public: ->
        console.log('public')

    window.app_router = new MainRouter
    Backbone.history.start({pushState: true})
