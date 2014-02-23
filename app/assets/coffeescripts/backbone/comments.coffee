App.Comments = Backbone.Collection.extend
  model: App.Comment
  url: -> "/resources/#{@resourceId}/comments"
