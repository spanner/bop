jQuery ($) ->
  class Block extends Bop.Module
    constructor: (element, @_space, @_type) ->
      @_container = $(element)
      @_container.addClass('editable')
      @_page = @_space.page()
      @_id = @_container.attr('data-bop-block')
      @create() unless @_id?
      @ready()
    
    id: () => 
      @_id
    
    ready: (e) =>
      @_container.bind "dblclick", @edit
      @_space.sortable()
      
    default_content: () =>
      switch @_type
        when "text" then $("<p>Double-click to edit!</p>")
        when "image" then $('<div class="uploader" />')

    create: () =>
      $.ajax
        url: "/bop/pages/#{@_page.id()}/blocks"
        type: "POST"
        dataType: "JSON"
        data: 
          space: @_space.name()
          block: 
            content: @_container.html()
        error: @error
        success: @created

    created: (response) =>
      @_id = response.id
      @_container.attr('data-bop-block', @_id)
      @_container.flash("#8dd169")
    
    edit: (e) =>
      e.preventDefault()
      @_container.unbind "dblclick", @edit
      @_space.unsortable()
      @_editor = new BlockEditor @_container, @
      
    update: (content) =>
      $.ajax
        url: "/bop/pages/#{@_page.id()}/blocks/#{@id()}"
        type: "PUT"
        data: 
          block: 
            content: content
        dataType: "JSON"
        success: @updated
        error: @error

    updated: (response) =>
      @_container.flash("#8dd169")
      @ready()

    error: (a, b, c) =>
      @_container.flash("#ff0000")
      console.log "Block save error", a, b, c
      @ready()
      
    destroy: () =>
      @_container.slideUp () =>
        #todo: destroy on server
        @_container.remove()
        @_content.destroy()
        delete @

  
  $.fn.bop_block = (space) ->
    @each ->
      new Bop.Block(@, space)
    @


  class BlockEditor extends Bop.Module
    constructor: (element, @_block) ->
      @_editable = $(element)
      @_id = @_editable.attr('data-bop-block')
      @_editable.wrap('<div class="editing" />')
      @_container = @_editable.parents('.editing')
      @_initial_content = @_editable.html()
      @show()

    revert: (e) =>
      e.preventDefault() if e
      @_controls.remove()
      @_editable.unwrap()
      @_editable.html(@_initial_content)
      @_block.ready()
      @trigger('complete')
      @trigger('revert')
      # stand down the various editors that might be in play

    submit: () =>
      # where are we getting our content from?
      @_controls.remove()
      @_editable.unwrap()
      @_block.update
        content: @_editable.html
      @trigger('complete')
      @trigger('submit')
    
    # don't show controls until we change something.
    show: () =>
      unless @_controls?
        @_controls = $("<div class='controls'><button class='submit ui-button ui-corner-all'>save</button><button class='cancel ui-button ui-corner-all'>cancel</a></div>")
        @_controls.find('.submit').bind "click", @submit
        @_controls.find('.cancel').bind "click", @revert
        @_editable.after @_controls
      @_controls.show()

    hide: () =>
      @_controls?.hide()





  $.namespace "Bop", (target, top) ->
    target.Block = Block
