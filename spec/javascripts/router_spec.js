(function() {

  require(['router', 'CodemarkCollection'], function(MainRouter, CodemarkCollection) {
    return describe('Router', function() {
      var router;
      router = new MainRouter;
      it('routes home to index', function() {
        return expect(router.routes['codemarks']).toEqual('index');
      });
      return it('routes public to index', function() {
        return expect(router.routes['public']).toEqual('public');
      });
    });
  });

}).call(this);
