describe 'Pagination', ->
  describe '#render', ->
    it 'returns unefined if not given a collection', ->
      @pagination = new App.Views.Pagination
      expect(@pagination.render()).toBeUndefined()

  describe 'toHtml', ->
    it 'has a pagination wrapper', ->
      @pagination = new App.Views.Pagination
        collection: new Backbone.Collection
          pagination: {total_pages: 2}
      @pagination.render()
      expect(@pagination.$el.filter('.pagination').length).toBe(1)
