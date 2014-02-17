App.FilemarkCodemarkView = App.CodemarkView.extend
  template: ->
    angelo('filemark_codemark.html')

  presentedAttributes: ->
    resource = @model.get('resource')
    data = App.CodemarkView.prototype.presentedAttributes.call(this)
    data['attachment_name'] = @model.get('resource').attachment_file_name
    data['attachment_url'] = @model.get('resource').attachment_url
    data['title_link'] =
      content: @model.get('title'),
      href: "/codemarks/#{@model.get('id')}"
    data
