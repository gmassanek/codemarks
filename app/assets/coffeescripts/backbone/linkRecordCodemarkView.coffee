App.LinkRecordCodemarkView = App.CodemarkView.extend
  template: ->
    angelo('link_record_codemark.html')

  presentedAttributes: ->
    resource = @model.get('resource')
    data = App.CodemarkView.prototype.presentedAttributes.call(this)
    data['description'] = @model.get('description')
    data['main-image'] =
      content: ''
      src: if resource.snapshot_url then resource.snapshot_url else '/assets/loading.gif'
    data['host'] = resource.host
    data['title_link'] =
      content: @model.get('title'),
      href: resource.url
    data
