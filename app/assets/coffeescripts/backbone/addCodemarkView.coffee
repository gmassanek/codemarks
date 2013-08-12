App.AddCodemarkView = Backbone.View.extend
  className: 'new_options'
  tagName: 'ul'

  events:
    'click .add_link a': 'addLink'
    'click .add_note a': 'addNote'
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
      resource_type: 'TextRecord'
    @trigger('turnIntoForm')

  showUrlForm: ->
    template = '<form><input name="url" placeholder="Paste Link"/><button>Add</button></form>'
    @$('.add_link').html(template)

  newLinkFormSubmitted: (e) ->
    e.preventDefault()
    url = $(e.currentTarget).find('input').val()
    if @createCodemarkFor(url)
      @trigger('turnIntoForm')
    else
      @showUrlForm()
      @$('.add_link').find('form').append('<br><label>Need a URL</label>')

  createCodemarkFor: (url) ->
    return unless url
    link = { url: url }
    @model = new App.Codemark
      resource: link
      resource_type: 'Link'

  registerCancelOnEscape: ->
    $(document).keyup (e) =>
      if (e.keyCode == 27)
        @render()
