App.TextFormView = App.CodemarkFormView.extend
  _render: ->
    @resizeTextArea(@$('textarea.text'))

  presentedAttributes: ->
    title: @model.get('title') || ''
    text: @model.get('resource').text || ''
    topics: @presentedTopics()

  data: ->
    data = App.CodemarkFormView.prototype.data.call(this)
    data['resource'] = { text: @$('.text').val() }
    data
