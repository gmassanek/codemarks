App.TextFormView = App.CodemarkFormView.extend
  events:
    'keyup textarea': 'textareaChanged'

  _renderPostDOM: ->
    console.log 'hi'
    @resizeTextArea(@$('textarea.text'))

  template: ->
    angelo('textForm.html')

  presentedAttributes: ->
    title: @model.get('title') || ''
    text: @model.get('resource').text || ''
    topics: @presentedTopics()

  data: ->
    data = App.CodemarkFormView.prototype.data.call(this)
    data['resource'] = { text: @$('.text').val() }
    data

  textareaChanged: (e) ->
    @resizeTextArea($(e.currentTarget))

  resizeTextArea: ($textarea) ->
    val = $textarea.val()
    $hiddenDiv = @$('.text-height-container')
    console.log $hiddenDiv
    $hiddenDiv.html(val.replace(/\n/g, '<br>') + "</br></br></br>")
    console.log $hiddenDiv.height()
    @$('textarea.text').css('height', $hiddenDiv.height())
