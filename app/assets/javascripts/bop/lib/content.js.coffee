jQuery ($) ->
  class Content extends Bop.Module
    constructor: (element, callback) ->
      @_container = $(element)
      @_submitter = callback
      @_initial_content = @_container.html()
      @_container.bind "dblclick", @edit
      @ready()
      
    revert: (e) =>
      e.preventDefault() if e
      @_container.attr('contenteditable', false)
      @_container.html(@_initial_content)
      @_controls?.remove()
      @ready()
      
    ready: () =>
      @_container.bind "dblclick", @edit
      @_container.removeClass('editing')
      @_container.addClass('editable')

    edit: (e) =>
      e.preventDefault()
      @_container.unbind "dblclick", @edit
      @_container.attr('contenteditable', true)
      @show_controls()
      @_container.bind 'keyup', @position_controls
      @_container.addClass('editing')
      @_container.focus()
      
    show_controls: () =>
      unless @_controls?
        @_controls = $("<div class='controls'><a href='#' class='submit'>save</a> or <a href='#' class='cancel'>cancel</a></div>")
        @_controls.find('.submit').bind "click", @submit
        @_controls.find('.cancel').bind "click", @revert
        @_container.after(@_controls)
      @_controls.css
        top: @_container.position().top + @_container.height()
        left: @_container.position().left
      @_controls.show()
    
    hide_controls: () =>
      @_controls?.hide()
    
    submit: () =>
      @hide_controls()
      @_submitter?(@_container.html())
      @ready()



  $.namespace "Bop", (target, top) ->
    target.Content = Content


