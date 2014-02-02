App.ModalView = Backbone.View.extend
  openAsModal: ->
    $('body').append(@$el)
    @$el.dialog
      modal: true
      closeOnEscape: true
      autoOpen: true
      width: 610
      height: 450
    $('.ui-widget-header').remove()
    $('.ui-widget-overlay').on 'click', => @close()
    @$el.closest('.ui-dialog').focus()

  close: ->
    @view?.remove()
    if @options.modal
      @$el.dialog('close')
