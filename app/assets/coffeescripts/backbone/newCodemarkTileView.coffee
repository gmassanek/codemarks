App.NewCodemarkTileView = Backbone.View.extend
  id: 'new_codemarks'
  className: 'codemark'
  tagName: 'article'

  events:
    'click .new_link a': 'newLinkClicked'
    'submit .new_link form': 'newLinkFormSubmitted'

  render: ->
    template = angelo('newCodemarkTile.html')
    @$el.html(template)

  newLinkClicked: (e) ->
    e.preventDefault()
    @showUrlForm()

  showUrlForm: ->
    template = '<form><input placeholder="Paste Link"/><button>Add</button></form>'
    @$('.new_link').html(template)

  newLinkFormSubmitted: (e) ->
    e.preventDefault()
    url = $(e.currentTarget).find('input').val()
    @fetchFullFormFor(url)

  fetchFullFormFor: (url) ->
    data = { url: url }
    #@$el.load("/codemarks/new?url=#{url}")
    @$('.new_link').html('<a class="icon-link-2">New Link</a>')
