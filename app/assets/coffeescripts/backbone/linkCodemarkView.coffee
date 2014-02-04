App.LinkCodemarkView = App.CodemarkView.extend
  extraEvents:
    'click a.image_link': 'recordClick'
    'click a.title_link': 'recordClick'

  template: ->
    angelo('link_codemark.html')

  presentedAttributes: ->
    resource = @model.get('resource')
    data = App.CodemarkView.prototype.presentedAttributes.call(this)
    data['description'] = @model.get('description')
    data['main-image'] =
      content: ''
      src: if resource.snapshot_url then resource.snapshot_url else '/assets/loading.gif'
    data['host'] = resource.host
    data['image_link@href'] = resource.url
    data['title_link@href'] = resource.url
    data

  recordClick: (e) ->
    url = "/resources/#{@model.get('resource').id}/click"
    $.ajax
      type: 'POST'
      url: url
      data:
        resource_type: 'Link'
    $(e.currentTarget).unbind('click')
    if _gaq?
      _gaq.push(['_trackEvent', 'codemark', 'visit', @model.get('resource').url])
