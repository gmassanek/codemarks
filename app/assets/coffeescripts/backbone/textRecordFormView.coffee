App.TextRecordFormView = App.CodemarkFormView.extend
  template: ->
    angelo('textRecordForm.html')

  presentedAttributes: ->
    title: @model.get('title') || ''
    text: @model.get('resource').text || ''
    topics: @presentedTopics()

  data: ->
    data = App.CodemarkFormView.prototype.data.call(this)
    data['resource'] = { text: @$('.text').val() }
    data
