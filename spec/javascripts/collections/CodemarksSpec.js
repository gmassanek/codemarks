(function() {

  describe('CodemarkCollection', function() {
    it('defaults url to /codemarks', function() {
      var coll;
      coll = new App.Collections.Codemarks;
      return expect(coll.url).toBe('/codemarks');
    });
    return it('accepts a different url', function() {
      var coll;
      coll = new App.Collections.Codemarks('/public');
      return expect(coll.url).toBe('/public');
    });
  });

}).call(this);
