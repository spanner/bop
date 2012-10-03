jQuery ($) ->
  class Content extends Bop.Module
    constructor: (element) ->
      @_container = $(element)
      @_page_id = @_container.attr('data-bop-page')
      @_initial_value = @_container.text()
      @_data_field = @_container.attr('data-field')
      @show()

    revert: (e) =>
      e.preventDefault() if e
      @_container.attr('contenteditable', false)
      @_container.text(@_initial_value)
      @_controls.remove()
      @show()
      
    show: () =>
      @_container.bind "click", @edit
      @_container.removeClass('editing')

    edit: (e) =>
      e.preventDefault()
      @_container.unbind "click", @edit
      @_container.attr('contenteditable', true)
      @_controls = $("<div class='controls'><a href='#' class='submit'>save</a> or <a href='#' class='cancel'>cancel</a></div>").appendTo('#content')
      @_submitter = @_controls.find('.submit').bind "click", @submit
      @_canceller = @_controls.find('.cancel').bind "click", @revert
      @_controls.css
        position: "absolute"
        left: @_container.position().left
      @position_controls()
      @_container.bind 'keyup', @position_controls
      @_container.addClass('editing')
      @_container.focus()
      
    position_controls: () =>
      @_controls.css
        top: @_container.position().top + @_container.height()
    
    submit: () =>
      data = {}
      data["page[#{@_data_field}]"] = @_container.text() 
      $.ajax
        url: "/bop/pages/#{@_page_id}.js"
        type: "PUT"
        data: data
        dataType: "html"
        success: @update
        error: @error
    
    error: (a, b, c) =>
      console.log a, b, c
      @revert()
              
    update: () =>
      @_initial_value = @_container.text()
      @revert()
      
  $.fn.bop_content = (space) ->
    @each ->
      new Bop.Content @


  $.namespace "Bop", (target, top) ->
    target.Content = Content


