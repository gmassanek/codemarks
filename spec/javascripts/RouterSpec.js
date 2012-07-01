(function() {

  describe('Router', function() {
    var router;
    router = new App.MainRouter;
    describe('routes pages like', function() {
      it('public to Codemarks#public', function() {
        return expect(router.routes['public']).toEqual('public');
      });
      return it('passes showCodemarkList to succes? - Should you test what function you pass?', function() {});
    });
    return describe('#showCodemarkList', function() {
      it('has better tests than the next to that know all about implementation', function() {});
      it('renders the CodemarkList view with the incoming codemarks', function() {});
      return it('appends that to the dom', function() {});
    });
  });

}).call(this);
