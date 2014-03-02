App.CodemarkFormView = Backbone.View.extend
  className: 'codemark_form'
  tagName: 'form'

  events:
    'click .cancel': 'cancel'
    'submit': 'submit'
    'keyup textarea.autosize': 'autoSize'

  render: ->
    if @model.hasNewResource() && @model.get('resource_type') == 'Link'
      @fetchFullFormFor(@model.get('resource').url)
      return

    @$el.html(@toHtml())
    @$('.topics').select2
      tags: App.topics.slugs()

    @hideResourceEditsIfNotAuthor()
    @renderGroups()
    @_render?()

  renderGroups: ->
    groups = App.current_user.groups()
    groups.unshift ( { id: '', name: 'None' } )
    _.each groups, (group) =>
      optionHtml = "<option value='#{group.id}'>#{group.name}</option>"
      @$('.group_id').append(optionHtml)

    if groups.length == 1
      @$('.group_id').hide()
      @$('.group_label').remove()

    @$('.group_id').val(@model.get('group_id'))

  hideResourceEditsIfNotAuthor: ->
    if @resourceEditable()
      @$('.read-only-resource').remove()
    else
      @$('.editable-resource').remove()

  toHtml: ->
    facile(@template(), @presentedAttributes())

  presentedTopics: ->
    slugs = _.map @model.get('topics'), (topic) ->
      topic.slug
    slugs.join()

  cancel: ->
    @trigger('cancel')

  mode: ->
    if @model.get('id')?
      'update'
    else
      'new'

  resourceEditable: ->
    !@model.get('resource').id? || parseInt(@model.get('resource').author_id) == parseInt(CURRENT_USER_ID)

  submit: (e) ->
    e.preventDefault()
    @updateCodemark()

  updateCodemark: ->
    if @model.get('id')
      $.ajax
        type: 'PUT'
        url: "/codemarks/#{@model.get('id')}"
        data: @data()
        dataType: 'json'
        success: (response) =>
          @model.attributes = JSON.parse(response.codemark)
          @model.trigger('change')
          @trigger('updated')
          @trigger('cancel')
    else
      $.ajax
        type: 'POST'
        url: '/codemarks'
        data: @data()
        success: (response) =>
          App.codemarks?.add(JSON.parse(response.codemark))
          @trigger('created')
          @trigger('cancel')

  data: ->
    data = codemark:
      title: @$('.title').val()
      description: @$('.description').val()
      resource_type: @model.get('resource_type')
      resource_id: @model.get('resource').id
      source: @options.source
    data.codemark.group_id = @$('.group_id').val()
    data.codemark['topic_ids'] = @$('input.topics').val() if @$('input.topics').val()?
    data

  codemarklet: ->
    $('.codemarklet').length > 0

  modal: ->
    @$el.closest('.ui-dialog-content').length > 0

  autoSize: (e) ->
    @resizeTextArea($(e.currentTarget))

  resizeTextArea: ($textarea) ->
    return if @codemarklet() || @modal()
    val = $textarea.val()
    if val && val.length > 0
      $hiddenDiv = @$('.text-height-container')
      $hiddenDiv.html(val.replace(/\n/g, '<br>') + "</br></br></br></br>")
      @$('textarea.text').css('height', $hiddenDiv.height())
