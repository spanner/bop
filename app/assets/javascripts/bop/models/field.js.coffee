jQuery ($) ->
  class Field extends Bop.Module
    constructor: (element, @_page) ->
      @_container = $(element)
      @_container.addClass('editable')
      @_fieldname = @_container.attr('data-bop-field')
      @ready()
      
    ready: () =>
      @_container.attr('contenteditable', false)
      @_container.bind "dblclick", @startEditing
      
    startEditing: () =>
      @_initial_content = @_container.html()
      @_container.unbind "dblclick", @edit
      @_container.wrap('<div class="editing" />')
      @_wrapper = @_container.parents().find('.editing').first()
      @_controls = $("<div class='controls'><button class='submit ui-button ui-corner-all'>save</button> <button class='cancel ui-button ui-corner-all'>cancel</a></div>").appendTo(@_wrapper)
      @_controls.find('.submit').bind "click", @submit
      @_controls.find('.cancel').bind "click", @revert
      @_container.attr('contenteditable', true)
      @_wrapper.bind 'mouseenter', @showControls
      @_wrapper.bind 'mouseleave', @hideControls
      @_container.bind 'keydown', @shortcutKeys
    
    stopEditing: () =>
      @_controls.remove()
      @_container.unwrap()
      
    showControls: (e) =>
      @_controls?.stop().fadeIn('fast')

    hideControls: (e) =>
      @_controls?.stop().fadeOut('slow')
    
    shortcutKeys: (e) =>
      console.log "shortcutKeys", e.which
      switch e.which
        when 27
          @revert(e)
        when 13, 83
          @submit(e) if e.metaKey or e.ctrlKey
      
    revert: (e) =>
      e.preventDefault() if e
      console.log "Field revert", @_fieldname
      @stopEditing()
      @_container.html @_initial_content
      @ready()
      
    submit: (e) =>
      e.preventDefault() if e
      content = @_container.html()
      console.log "Field save", @_fieldname, @_page, content
      @stopEditing()
      data = 
        page: {}
      data['page'][@_fieldname] = content
      $.ajax
        url: "/bop/pages/#{@_page.id()}"
        type: "PUT"
        data: data
        dataType: "json"
        success: @confirm
        error: @error

    confirm: (response) =>
      @_container.flash("#8dd169")
      @ready()

    error: (a, b, c) =>
      @_container.flash("#FF0000")
      console.log "Field save error", a, b, c
      @ready()
      
    
  $.fn.bop_field = (space) ->
    @each ->
      new Bop.Field(@, space)


  $.namespace "Bop", (target, top) ->
    target.Field = Field
