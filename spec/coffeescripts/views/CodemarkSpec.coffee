describe 'Codemark', ->
  it 'does not have a save link if it\'s already mine', ->
    codemark = new App.Models.Codemark
      mine: true
    codemarkView = new App.Views.Codemark
      model: codemark
    codemarkView.render()
    expect(codemarkView.$('.copy_codemark').length).toBe(0)
    expect(codemarkView.$('.title').length).toBe(1)
