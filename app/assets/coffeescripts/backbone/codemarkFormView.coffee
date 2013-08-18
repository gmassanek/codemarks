App.CodemarkFormView = Backbone.View.extend
  className: 'codemark_form'
  tagName: 'form'

  events:
    'click .cancel': 'cancel'
    'submit': 'submit'

  render: ->
    if @model.hasNewResource() && @model.get('resource_type') == 'Link'
      @fetchFullFormFor(@model.get('resource').url)
      return

    @$el.html(@toHtml())
    @$('.topics').select2
      tags: App.topics.slugs()

    @hideResourceEditsIfNotAuthor()
    @openAsModal()

  hideResourceEditsIfNotAuthor: ->
    if @resourceEditable()
      @$('.read-only-resource').remove()
    else
      @$('.editable-resource').remove()

  openAsModal: ->
    if !@codemarklet()
      @$el.dialog
        modal: true
        closeOnEscape: true
        width: 610
        height: 450
      $('.ui-widget-header').hide()
      $('.ui-widget-overlay').on 'click', => @cancel()

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
    @model.get('resource').author_id == CURRENT_USER_ID

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
    else
      $.ajax
        type: 'POST'
        url: '/codemarks'
        data: @data()
        success: (response) =>
          @trigger('created', JSON.parse(response.codemark))

  data: ->
    data = codemark:
      title: @$('.title').val()
      description: @$('.description').val()
      resource_type: @model.get('resource_type')
      resource_id: @model.get('resource').id
    data.codemark['topic_ids'] = @$('input.topics').val() if @$('input.topics').val()?
    data

  codemarklet: ->
    $('.codemarklet').length > 0
