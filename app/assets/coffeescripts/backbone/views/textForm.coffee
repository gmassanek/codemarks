App.Views.TextForm = Backbone.View.extend
  id: 'codemark-form-container'

  event:
    'keydown': 'keyPressed'

  initialize: ->
    @user = @options.user
    @html = @options.html
    $('body').on 'keydown', (e) => @keyPressed(e)

  keyPressed: (e) ->
    if e.keyCode == 27
      @close()

  render: ->
    @$el.append(@toHtml())

  toHtml: ->
    $cont = $('<div class="a"></div>')
    $cont.append('<div class="overlay"></div>')
    $cont.append(@html)
    $cont

  close: ->
    @remove()
