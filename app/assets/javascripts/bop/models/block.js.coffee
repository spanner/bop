jQuery ($) ->
  class Block extends Bop.Module
    constructor: (element, @_space) ->
      @_container = $(element)
      @_page = @_space.page()
      @_id = @_container.attr('data-bop-block')
      @create() unless @_id?
      @_content = new Bop.Content @_container, @update
    
    id: () => 
      @_id
    
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
      console.log "block created", response
      @_id = response.id
      @_container.attr('data-bop-block', @_id)

    update: (content) =>
      data = 
        block: 
          content: content

      data[@_fieldname] = content
      $.ajax
        url: "/bop/pages/#{@_page.id()}/blocks/#{@id()}"
        type: "PUT"
        data: data
        dataType: "JSON"
        success: @updated
        error: @error
      
    updated: (response) =>
      @_container.flash("#8dd169")

    error: (a, b, c) =>
      @_container.flash("#ff0000")
      console.log "Block save error", a, b, c
      
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
    

  $.namespace "Bop", (target, top) ->
    target.Block = Block
