App.AddCodemarkView = Backbone.View.extend
  className: 'new_options'
  tagName: 'ul'

  events:
    'click .add_link a': 'addLink'
    'click .add_note a': 'addNote'
    'click .add_file a': 'addFile'
    'click .add_image a': 'addImage'
    'submit .add_link form': 'newLinkFormSubmitted'

  render: ->
    template = angelo('addCodemark.html')
    @$el.html(template)
    @registerCancelOnEscape()

  addLink: (e) ->
    e.preventDefault()
    @showUrlForm()

  addNote: (e) ->
    e.preventDefault()
    @model = new App.Codemark
      resource: {}
      resource_type: 'Text'
    @turnIntoForm()

  addFile: (e) ->
    e.preventDefault()
    @model = new App.Codemark
      resource: {}
      resource_type: 'Filemark'
    @turnIntoForm()

  addImage: (e) ->
    e.preventDefault()
    @model = new App.Codemark
      resource: {}
      resource_type: 'ImageFile'
    @turnIntoForm()

  turnIntoForm: ->
    view = new App.EditCodemarkParentView
      model: @model
      source: @options.source
    view.render()
    @trigger('swapView', view)

  showUrlForm: ->
    template = "<form><input name='url' placeholder='Paste Link''/><button>Add</button></form>"
    @$('.add_link').html(template)
    @$('input[name=url]').val(window.incomingUrl) if window.incomingUrl

  newLinkFormSubmitted: (e) ->
    e.preventDefault()
    url = $(e.currentTarget).find('input').val()
    if @createCodemarkFor(url)
      @turnIntoForm()
    else
      @showUrlForm()
      @$('.add_link').find('form').append('<br><label>Need a URL</label>')

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
