define [], () ->
  MainRouter = Backbone.Router.extend
    routes:
      'public': 'public'

    public: ->
      console.log('public')
