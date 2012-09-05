jQuery ($) ->
  class Block extends Bop.Module
    constructor: (element, @_space) ->
      @_container = $(element)
      @_id = @_container.attr('data-bop-block')
      if @_id? then @show() else @new()
    
    replaceWith: (element) =>
      new_container = $(element)
      @_container.after(new_container).remove()
      @_container = new_container

    replaceProvisionallyWith: (element) =>
      new_container = $(element)
      @_original_container = @_container
      @_container.after(new_container).hide()
      @_container = new_container
      @_container.find('a.cancel').click(@revert)
    
    revert: () =>
      e.preventDefault() if e
      unless @_container is @_original_container
        @_container.remove() 
        @_container = @_original_container
      @_container.show()
      
    element: () =>
      @_container

    new: () =>
      @_form = @_container.find('form.new_block')
      @_form.remote_form(@create)
      @_form.find('a.cancel').click(@abandon)
      @_container.addClass('editing')
    
    abandon: (e) =>
      e.preventDefault() if e
      @_container.slideUp () =>
        @_container.remove()
        delete @
        
    create: (response) =>
      @replaceWith(response)
      @_id = @_container.attr('data-bop-block')
      @show()

    show: () =>
      @_container.removeClass('editing')
      @_editor = $("<a href='/bop/pages/#{$.page_id}/blocks/#{@_id}/edit' class='editor' data-type='html'>edit</a>").prependTo(@_container).remote_link(@edit)
      @_remover = $("<a href='#' class='remover' data-remote='true' data-method='delete' data-type='html'>remove</a>").prependTo(@_container).remote_link(@destroy)
      
    edit: (reponse) =>
      @replaceProvisionallyWith(reponse)
      @_form = @_container.find('form.edit_block')
      @_form.remote_form(@update)
      @_container.addClass('editing')

    update: (response) =>
      @replaceWith(response)
      @show()
      
    destroy: () =>
      console.log "destroy"
      @_container.slideUp()

  
  $.fn.bop_block = (space) ->
    @each ->
      new Bop.Block(@, space)


  $.namespace "Bop", (target, top) ->
    target.Block = Block
