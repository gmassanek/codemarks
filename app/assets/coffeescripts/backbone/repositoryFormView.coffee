App.RepositoryFormView = App.CodemarkFormView.extend
  template: ->
    angelo('repositoryForm.html')

  presentedAttributes: ->
    title: @model.get('title') || ''
    description: @model.get('description') || ''
    topics: @presentedTopics()

  data: ->
    data = App.CodemarkFormView.prototype.data.call(this)
    data['resource'] = {}
    data
