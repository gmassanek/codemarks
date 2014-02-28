App.FilemarkFormView = App.CodemarkFormView.extend
  _render: ->
    @$('#attachment').fileupload
      add: (e, data) =>
        data.submit()

      success: (data) =>
        @model.set('resource', data)
        @$('#attachment').replaceWith("<div>#{data.attachment_file_name}</div>")

      error: (data) =>
        @$el.prepend("<div>#{data.responseText}</div>")

  template: ->
    angelo('filemarkForm.html')

  presentedAttributes: ->
    title: @model.get('title') || ''
    topics: @presentedTopics()
