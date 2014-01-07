App.User = Backbone.Model.extend
  initialize: ->

  groups: ->
    (@get('groups') || []).slice(0)

  authorizedForGroup: (groupId) ->
    !groupId? || @groupFor(groupId)?

  groupFor: (groupId) ->
    _.find @groups(), (group) =>
      group.id == parseInt(groupId)
