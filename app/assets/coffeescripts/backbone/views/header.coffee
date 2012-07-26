App.Views.Header = Backbone.View.extend
  el: '#header'

  events:
    'click #add_text_codemark': 'openTextCodemarkForm'

  openTextCodemarkForm: (e) ->
    e.preventDefault()
    $.ajax
      url: "/codemark_forms/text?saver=#{USER_ID}"
      dataType: 'html'
      error: ->
        console.log 'help'
      success: (response) ->
        textForm = new App.Views.TextForm
          user: USER_ID
          html: $(response)
        textForm.render()

        $('body').append(textForm.$el)
