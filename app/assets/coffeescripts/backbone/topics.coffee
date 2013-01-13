App.Topics = Backbone.Collection.extend
  model: App.Topic
  url: '/topics'

  slugs: ->
    _.map @models, (topic) ->
      topic.get('slug')
