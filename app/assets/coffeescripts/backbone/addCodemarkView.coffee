App.AddCodemarkView = Backbone.View.extend
  className: 'add_codemark'
  tagName: 'ul'

  events:
    'click .add-link a': 'addLink'
    'click .add-note a': 'addNote'
    'click .add-file a': 'addFile'
    'click .add-image a': 'addImage'
    'submit form': 'newLinkFormSubmitted'

  render: ->
    template = angelo('add_codemark.html')
    @$el.html(template)
    @registerCancelOnEscape()

  addCodemarkClicked: (e) ->
    e?.preventDefault()
    if App.current_user.get('id')?
      @openNewCodemarkModal()
    else
      window.location = '/sessions/new'

  addLink: (e) ->
    e.preventDefault()
    window.location = '/sessions/new' unless App.current_user.get('id')?
    @showUrlForm()

  addNote: (e) ->
    e.preventDefault()
    window.location = '/sessions/new' unless App.current_user.get('id')?
    @model = new App.Codemark
      resource: {}
      resource_type: 'Text'
    @turnIntoForm()

  addFile: (e) ->
    e.preventDefault()
    window.location = '/sessions/new' unless App.current_user.get('id')?
    @model = new App.Codemark
      resource: {}
      resource_type: 'Filemark'
    @turnIntoForm()

  addImage: (e) ->
    e.preventDefault()
    window.location = '/sessions/new' unless App.current_user.get('id')?
    @model = new App.Codemark
      resource: {}
      resource_type: 'ImageFile'
    @turnIntoForm()

  turnIntoForm: ->
    view = new App.EditCodemarkParentView
      model: @model
      source: @options.source
      modal: @options.modal
    view.render()
    @trigger('swapView', view)
    @render()

  showUrlForm: ->
    template = angelo('new_link_url_form.html')
    @$el.html(template)
    @$('input[name=url]').val(window.incomingUrl) if window.incomingUrl

  newLinkFormSubmitted: (e) ->
    e.preventDefault()
    url = $(e.currentTarget).find('input').val()
    if @createCodemarkFor(url)
      @turnIntoForm()
    else
      @showUrlForm()
      @$('.add-link').find('form').append('<br><label>Need a URL</label>')

  createCodemarkFor: (url) ->
    return unless url
    if window.App.codemark? && url == window.App.codemark?.get('resource').url
      @model = window.App.codemark
    else
      @model = new App.Codemark
        resource: { url: url }
        resource_type: 'Link'

  registerCancelOnEscape: ->
    $(document).keyup (e) =>
      if (e.keyCode == 27)
        @render()
