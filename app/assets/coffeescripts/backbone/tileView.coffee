App.TileView = Backbone.View.extend
  className: 'tile'
  tagName: 'section'

  initialize: ->
    @model = new App.Codemark unless @model?

  render: ->
    @renderCodemarkView() if @model.exists()
    if CURRENT_USER == ''
      @$el.addClass('logged-out')

  replaceElWithView: ->
    @$el.html(@view.$el)

  bindToView: ->
    @view.bind 'turnIntoForm', => @turnViewIntoForm()
    @view.bind 'cancel', => @handleCancel()
    @view.bind 'updated', => @handleUpdated()
    @view.bind 'delete', => @delete()
    @view.bind 'createCopy', => @copyForNewUser()

  delete: ->
    @$el.fadeOut 500, =>
      @remove()

  handleCancel: ->
    if @modelToCopy?
      @model = @modelToCopy
      delete @modelToCopy
    @render()

  handleUpdated: ->
    @view.remove()
    @render()

  renderCodemarkView: ->
    @view = new App["#{@model.get('resource_type')}CodemarkView"]
      model: @model
      navigable: @options.navigable
    @view.render()

    @replaceElWithView()
    @bindToView()

  turnViewIntoForm: ->
    @model = @view.model
    @view = new App.EditCodemarkParentView
      model: @model
      modal: true
      source: 'web'
    @view.render()
    @bindToView()

  copyForNewUser: ->
    if App.current_user.get('id')?
      @modelToCopy = @view.model
      @view.model = new App.Codemark
        resource_type: @model.get('resource_type')
        resource: @model.get('resource')
        topics: @model.get('topics')
        title: @model.get('title')
      @turnViewIntoForm()
    else
      window.location = '/sessions/new'
