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
    data['pushed_at' ] = resource.pushed_at
    data['repo_created_at' ] = resource.repo_created_at
    data['owner_avatar_url' ] = resource.owner_avatar_url
    data['owner_gravatar_id' ] = resource.owner_gravatar_id
    data['fork' ] = resource.fork
    data['size' ] = resource.size
    data['data' ] = resource.data
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
