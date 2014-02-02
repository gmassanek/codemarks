App.AddCodemarkParentView = App.ModalView.extend
  initialize: ->
    @view = new App.AddCodemarkView
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
