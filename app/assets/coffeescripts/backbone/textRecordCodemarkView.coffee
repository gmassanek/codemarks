App.TextRecordCodemarkView = App.CodemarkView.extend
  template: ->
    angelo('text_record_codemark.html')

  presentedAttributes: ->
    console.log @model.attributes
    resource = @model.get('resource')
    data = App.CodemarkView.prototype.presentedAttributes.call(this)
    data['text'] = @model.get('resource').text
    data['title_link'] =
      content: @model.get('title'),
      href: 'http://google.com'
    console.log data
    data
