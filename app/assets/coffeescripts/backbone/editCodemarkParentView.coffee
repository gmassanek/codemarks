App.EditCodemarkParentView = App.ModalView.extend
  initialize: ->
    @view = new App["#{@model.get('resource_type')}FormView"]
      model: @model
      source: @options.source
    @bindToView()

  render: ->
    @$el.html(@view.el)
    if @options.modal
      @openAsModal()
    @view.render()

  bindToView: ->
    @view.bind('cancel', => @close())
    @view.bind('cancel', => @trigger('cancel'))
    @view.bind('updated', => @trigger('updated'))
    @view.bind('created', => @trigger('created'))
