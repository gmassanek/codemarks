describe 'Pagination', ->
  beforeEach ->
    @pagination = new App.PaginationView
      collection: new Backbone.Collection

  describe '#render', ->
    it 'returns undefined if not given a collection', ->
      expect(@pagination.render()).toBeUndefined()

    it 'is empty if there are no pages', ->
      @pagination.collection.pagination = {total_pages: 0}
      @pagination.render()
      expect(@pagination.$('a.page').length).toBe(0)

    it 'is empty if there is only one page', ->
      @pagination.collection.pagination = {total_pages: 1}
      @pagination.render()
      expect(@pagination.$('a.page').length).toBe(0)

    it 'renders a page link for each page', ->
      @pagination.collection.pagination = {total_pages: 3}
      @pagination.render()
      expect(@pagination.$('a.page').length).toBe(3)
