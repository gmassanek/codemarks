App.RepositoryCodemarkView = App.CodemarkView.extend
  extraEvents:
    'click .title': 'recordClick'

  template: ->
    angelo('repository_codemark.html')

  presentedAttributes: ->
    resource = @model.get('resource')
    data = App.CodemarkView.prototype.presentedAttributes.call(this)
    data['title_link'] =
      content: "#{resource.owner_login}/#{@model.get('title')}",
      href: "/codemarks/#{@model.get('id')}"
    data['description'] = resource.description
    data['forks_count'] = resource.forks_count
    data['watchers_count'] = resource.watchers_count
    data['language'] = resource.language
    data['owner_login'] = resource.owner_login
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
