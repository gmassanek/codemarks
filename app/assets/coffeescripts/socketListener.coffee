class App.SocketListener
  constructor: ->
    App.pusher = new Pusher('b97a760701c9f4a50b5b')
    @channel = App.pusher.subscribe('codemarks')
    @channel.bind 'snapshot:loaded', @refreshCodemark

  refreshCodemark: (data) =>
    model = App.codemarks.where(resource_id: data.resourceId)[0]
    model?.fetch()
