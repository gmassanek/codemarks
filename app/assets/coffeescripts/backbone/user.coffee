App.User = Backbone.Model.extend
  initialize: ->

  groups: ->
    (@get('groups') || []).slice(0)

  authorizedForGroup: (groupId) ->
    !groupId? || @groupFor(groupId)?

  authorizedForTopics: (topicSlugs) ->
    if topicSlugs?.length > 0
      unauthorized = _.reject topicSlugs, (slug) =>
        (_.find App.topics.slugs(), (slug2) => slug == slug2)?
      _.each unauthorized, (slug) => App.codemarks.filters.removeTopic(slug)
      unauthorized.length == 0
    else
      true

  groupFor: (groupId) ->
    _.find @groups(), (group) =>
      group.id == parseInt(groupId)
