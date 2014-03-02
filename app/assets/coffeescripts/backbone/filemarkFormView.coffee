App.FilemarkFormView = App.CodemarkFormView.extend
  _render: ->
    @$('#attachment').fileupload
      add: (e, data) =>
        data.submit()

      success: (data) =>
        @model.set('resource', data)
        @$('#attachment').replaceWith("<div class='filename'>#{data.attachment_file_name}</div>")

      error: (data) =>
        @$el.prepend("<div class='filename'>#{data.responseText}</div>")

      progress: (e, data) =>
        console.log data.loaded
        console.log data.total

  template: ->
    angelo('filemarkForm.html')

  presentedAttributes: ->
    title: @model.get('title') || ''
    topics: @presentedTopics()
