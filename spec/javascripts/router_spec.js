(function() {

  require(['router'], function(MainRouter) {
    return describe('Router', function() {
      var router;
      router = new MainRouter;
      return it('routes home to index', function() {
        return expect(router.routes['codemarks']).toEqual('index');
      });
    });
  });

}).call(this);
