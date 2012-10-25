App.NewCodemarkTileView = Backbone.View.extend
  id: 'new_codemarks'
  className: 'codemark'
  tagName: 'article'

  events:
    'click .add_link a': 'addLink'
    'submit .add_link form': 'newLinkFormSubmitted'

  render: ->
    template = angelo('newCodemarkTile.html')
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
    @codemark = new App.Codemark
      resource: link
      resource_type: 'LinkRecord'

  turnIntoLinkForm: ->
    @trigger('turnIntoForm')

  fetchFullFormFor: (url) ->
    data = { url: url }
    #@$el.load("/codemarks/new?url=#{url}")
    @$('.new_link').html('<a class="icon-link-2">New Link</a>')
