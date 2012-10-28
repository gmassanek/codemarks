App.AddCodemarkView = Backbone.View.extend
  className: 'new_options'
  tagName: 'ul'

  events:
    'click .add_link a': 'addLink'
    'submit .add_link form': 'newLinkFormSubmitted'

  render: ->
    template = angelo('addCodemark.html')
    @$el.html(template)

  addLink: (e) ->
    e.preventDefault()
    @showUrlForm()

  showUrlForm: ->
    template = '<form><input placeholder="Paste Link"/><button>Add</button></form>'
    @$('.add_link').html(template)

  newLinkFormSubmitted: (e) ->
    e.preventDefault()
    url = $(e.currentTarget).find('input').val()
    if @createCodemarkFor(url)
      @turnIntoLinkForm()
    else
      @showUrlForm()
      @$('.add_link').find('form').append('<br><label>Need a URL</label>')

  createCodemarkFor: (url) ->
    return unless url
    link = { url: url }
    @model = new App.Codemark
      resource: link
      resource_type: 'LinkRecord'

  turnIntoLinkForm: ->
    @trigger('turnIntoForm')
