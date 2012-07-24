describe 'Pagination', ->
  describe '#render', ->
    it 'returns unefined if not given a collection', ->
      @pagination = new App.Views.Pagination
      @pagination = new App.Views.Pagination
      expect(@pagination.render()).toBeUndefined()

  describe 'toHtml', ->
    beforeEach ->
      @pagination = new App.Views.Pagination
      @$html = $(@pagination.toHtml())

    it 'has a pagination wrapper', ->
      expect(@$html.find('.pagination').length).toBe(1)
