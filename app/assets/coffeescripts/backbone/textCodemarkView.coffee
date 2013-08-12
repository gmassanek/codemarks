App.TextCodemarkView = App.CodemarkView.extend
  template: ->
    angelo('text_codemark.html')

  presentedAttributes: ->
    resource = @model.get('resource')
    data = App.CodemarkView.prototype.presentedAttributes.call(this)
    data['text'] = @model.get('resource').text
    data['title_link'] =
      content: @model.get('title'),
      href: "/codemarks/#{@model.get('id')}"
    data['add'] = null
    data
