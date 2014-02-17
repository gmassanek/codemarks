App.ImageFileFormView = App.FilemarkFormView.extend
  template: ->
    angelo('imageFileForm.html')

  presentedAttributes: ->
    title: @model.get('title') || ''
    topics: @presentedTopics()
