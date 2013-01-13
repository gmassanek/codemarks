describe 'TabsView', ->
  describe 'selectActiveTab', ->
    describe 'on the codemarks page', ->
      beforeEach ->
        App.router.onCodemarksPage = ->
          true
        @codemarks = new App.Codemarks
        @view = new App.TabsView
          el: $('<ul><li><a class="everyones">Browse</a><a class="yours">Mine</a></li></ul>')
          codemarks: @codemarks

      it 'sets Browse to active if no user is logged in', ->
        window.CURRENT_USER = null
        @view.selectActiveTab()
        expect(@view.$('.everyones').closest('li').hasClass('active')).toBe(true)

      it 'sets Browse to active if logged in user is not being filtered', ->
        window.CURRENT_USER = 'gmassanek'
        @view.selectActiveTab()
        expect(@view.$('.everyones').closest('li').hasClass('active')).toBe(true)

      it 'sets Mine to active if logged in user is not being filtered', ->
        window.CURRENT_USER = 'gmassanek'
        @codemarks.filters.setUser('gmassanek')
        @view.selectActiveTab()
        expect(@view.$('.yours').closest('li').hasClass('active')).toBe(true)


    describe 'not on the codemarks page', ->
      beforeEach ->
        App.router.onCodemarksPage = ->
          false
        @codemarks = new App.Codemarks
        @view = new App.TabsView
          el: $('<ul><li><a class="everyones">Browse</a><a class="yours">Mine</a></li></ul>')
          codemarks: @codemarks

      it 'has no active tabs', ->
        @view.selectActiveTab()
        expect(@view.$('.active').length).toBe(0)

      it 'clears existing active tabs', ->
        @view.$('li').addClass('active')
        @view.selectActiveTab()
        expect(@view.$('.active').length).toBe(0)
