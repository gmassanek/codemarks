App.FilemarkFormView = App.CodemarkFormView.extend
  _render: ->
    @setupFileUpload()
    if @model.get('resource').attachment_file_name?
      @$('#attachment').remove()

  setupFileUpload: ->
    @$('#attachment').fileupload
      add: (e, data) =>
        data.submit()

      success: (data) =>
        @model.set('resource', data)
        @$('#attachment').remove()
        @$('.file_name').text(data.attachment_file_name)

      error: (data) =>
        $errors = @$('ul.errors')
        $errors.html('')
        _.each JSON.parse(data.responseText), (error) =>
          $errors.append("<li>#{error}</li>")

      progress: (e, data) =>
        console.log data.loaded / data.total

  template: ->
    angelo('filemarkForm.html')

  presentedAttributes: ->
    data =
      title: @model.get('title') || ''
      topics: @presentedTopics()
    data['file_name'] = @model.get('resource').attachment_file_name if @model.get('resource').attachment_file_name?
