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
      expect(@pagination.$('a.page_link').length).toBe(0)

    it 'is empty if there is only one page', ->
      @pagination.collection.pagination = {total_pages: 1}
      @pagination.render()
      expect(@pagination.$('a.page_link').length).toBe(0)

    it 'renders a page link for each page', ->
      @pagination.collection.pagination = {total_pages: 3}
      @pagination.render()
      expect(@pagination.$('a.page_link').length).toBe(3)

    it "renders a page for 5 on each side of currentPage", ->
      @pagination.collection.pagination = {total_pages: 30}
      @pagination.currentPage = '15'
      @pagination.render()
      expect(@pagination.$('a.page_link').length).toBe(13)
      expect(@pagination.$('a[data-page=0]').length).toBe(0)
      expect(@pagination.$('a[data-page=10]').length).toBe(1)
      expect(@pagination.$('a[data-page=20]').length).toBe(1)
      expect(@pagination.$('a[data-page=21]').length).toBe(0)

    it "renders a page for 5 on each side of currentPage for huge #s", ->
      @pagination.collection.pagination = {total_pages: 99}
      @pagination.currentPage = 5
      @pagination.render()
      expect(@pagination.$('a.page_link').length).toBe(11)

    it "renders a 'first' link if needed", ->
      @pagination.collection.pagination = {total_pages: 99}
      @pagination.currentPage = 60
      @pagination.render()
      expect(@pagination.$('a[data-page=1]').length).toBe(1)
      expect(@pagination.$('a[data-info=first]').length).toBe(1)

    it "renders a 'last' link if needed", ->
      @pagination.collection.pagination = {total_pages: 99}
      @pagination.currentPage = 60
      @pagination.render()
      expect(@pagination.$('a[data-page=99]').length).toBe(1)
      expect(@pagination.$('a[data-info=last]').length).toBe(1)
