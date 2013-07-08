App.TextRecordFormView = App.CodemarkFormView.extend
  template: ->
    angelo('textRecordForm.html')

  presentedAttributes: ->
    url: @model.get('resource').url
    title: @model.get('title') || ''
    description: @model.get('description') || ''
    topics: @presentedTopics()

  data: ->
    data = App.CodemarkFormView.prototype.data.call(this)
    data['resource'] = { text: @$('.text').val() }
    data
