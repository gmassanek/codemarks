App.ImageFileCodemarkView = App.CodemarkView.extend
  template: ->
    angelo('image_file_codemark.html')

  presentedAttributes: ->
    resource = @model.get('resource')
    data = App.CodemarkView.prototype.presentedAttributes.call(this)
    data['main-image'] =
      content: ''
      src: resource.attachment_url
    data['title_link'] =
      content: @model.get('title'),
      href: "/codemarks/#{@model.get('id')}"
    data
