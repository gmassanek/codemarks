(function() {

  require(['CodemarkCollection'], function(CodemarkCollection) {
    return describe('CodemarkCollection', function() {
      it('defaults url to /codemarks', function() {
        var coll;
        coll = new CodemarkCollection;
        return expect(coll.url).toBe('/codemarks');
      });
      return it('accepts a different url', function() {
        var coll;
        coll = new CodemarkCollection('/public');
        return expect(coll.url).toBe('/public');
      });
    });
  });

}).call(this);
