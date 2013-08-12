App.TileView = Backbone.View.extend
  className: 'tile'
  tagName: 'section'

  initialize: ->
    @model = new App.Codemark unless @model?
    @isTheAddCodemarkTile = @options.add

  render: ->
    @renderCodemarkView() if @model.exists()
    @renderAddCodemarkView() if @isTheAddCodemarkTile
    if CURRENT_USER == ''
      @$el.addClass('logged-out')

  replaceElWithView: ->
    @$el.html(@view.$el)

  bindToView: ->
    @view.bind 'turnIntoForm', => @turnViewIntoForm()
    @view.bind 'cancel', => @handleCancel()
    @view.bind 'updated', => @handleUpdated()
    @view.bind 'created', (data) => @codemarkCreated(data)
    @view.bind 'delete', => @delete()
    @view.bind 'createCopy', => @copyForNewUser()

  delete: ->
    @$el.fadeOut 500, =>
      @remove()

  codemarkCreated: (data) ->
    App.codemarks.add(data)
    @view?.remove()
    if @modelToCopy?
      @remove()
    else
      @render()

  handleCancel: ->
    if @modelToCopy?
      @model = @modelToCopy
      delete @modelToCopy
    @view.remove()
    @render()

  handleUpdated: ->
    @view.remove()
    @render()

  renderCodemarkView: ->
    return if @isTheAddCodemarkTile

    @view = new App["#{@model.get('resource_type')}CodemarkView"]
      model: @model
    @view.render()

    @replaceElWithView()
    @bindToView()

  renderAddCodemarkView: ->
    return unless @isTheAddCodemarkTile
    @view = new App.AddCodemarkView
      model: @model
    @view.render()

    @replaceElWithView()
    @bindToView()

  turnViewIntoForm: ->
    @model = @view.model
    @view = new App["#{@model.get('resource_type')}FormView"]
      model: @model
    $('body').append(@view.el)
    @view.render()
    @bindToView()

  copyForNewUser: ->
    @modelToCopy = @view.model
    @view.model = new App.Codemark
      resource_type: @model.get('resource_type')
      resource: @model.get('resource')
      topics: @model.get('topics')
      title: @model.get('title')
    @turnViewIntoForm()
