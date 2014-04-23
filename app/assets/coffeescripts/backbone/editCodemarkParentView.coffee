App.EditCodemarkParentView = App.ModalView.extend
  initialize: ->
    @setupView(@model)

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
    @view.bind('rerender', (model) =>
      @setupView(model)
      @view.render()
      @$el.html(@view.el)
    )

  setupView: (model) ->
    @model = model
    @view = new App["#{@model.get('resource_type')}FormView"]
      model: @model
      source: @options.source
    @bindToView()
