App.AddCodemarkParentView = App.ModalView.extend
  initialize: ->
    @view = new App.AddCodemarkView
      source: @options.source
    @bindToView()

  render: ->
    @view.render()
    @$el.html(@view.el)
    if @options.modal
      @openAsModal()

  swapView: (view) ->
    @view.remove()
    @view = view
    @$el.html(@view.el)
    @bindToView()

  bindToView: ->
    @view.bind('cancel', => @close())
    @view.bind('swapView', (view) => @swapView(view))
    @view.bind('cancel', => @trigger('cancel'))
    @view.bind('updated', => @trigger('updated'))
    @view.bind('created', => @trigger('created'))
