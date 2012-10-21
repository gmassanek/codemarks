App.CodemarkFormView = Backbone.View.extend
  tagName: 'form'
  className: 'codemark_form'

  events:
    'click .cancel': 'cancel'
    'submit': 'submit'

  render: ->
    @$el.html(@toHtml())

  toHtml: ->
    template = angelo('codemarkForm.html')
    facile(template, @presentedAttributes())

  presentedAttributes: ->
    title: @model.get('title')
    description: @model.get('description') || ''
    topics: @presentedTopics()

  presentedTopics: ->
    _.map App.topics.models, (topic) ->
      possible_topic:
          value: topic.get('slug')
          content: topic.get('title')

  cancel: ->
    @trigger('cancel')

  submit: (e) ->
    e.preventDefault()
    @updateCodemark()

  updateCodemark: ->
    console.log @data()

  data: ->
    title: @$('.title').val()
    description: @$('.description').val()
