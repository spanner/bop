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
    
    element: () =>
      @_container

    revert: (e) =>
      e.preventDefault() if e
      unless @_container is @_original_container
        @_container.remove() 
        @_container = @_original_container
      @_container.show()

    new: () =>
      @_form = @_container.find('form.new_block')
      @_form.find('a.cancel').click(@abandon)
      @_form.html_editable()
      @_container.addClass('editing')
      @_form.remote_form(@create)
      @listen()
    
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
      @_controls = $('<div class="controls" />').prependTo(@_container)
      @_editor = $("<a href='/bop/pages/#{$.page_id}/blocks/#{@_id}/edit' class='editor icon' data-remote='true' data-type='html'>edit</a>").appendTo(@_controls).remote_link(@edit)
      @_remover = $("<a href='/bop/pages/#{$.page_id}/blocks/#{@_id}' class='remover icon' data-remote='true' data-method='delete' data-remote='true' data-type='html'>remove</a>").appendTo(@_controls).remote_link(@destroy)
      
    edit: (response) =>
      @replaceProvisionallyWith(response)
      @_form = @_container.find('form.edit_block')
      @_form.remote_form(@update)
      @_form.html_editable()
      @_container.addClass('editing')
      @listen()
      $('textarea').autosize()

    update: (response) =>
      @replaceWith(response)
      @show()
      
    destroy: () =>
      console.log "destroy"
      @_container.slideUp()

    listen: () =>
      @_types = @_container.find('.types')
      @_body_field = @_container.find('.body_field')
      @_asset_fields = @_container.find('.asset_fields')
      @_types.find('input').on "change", @toggle_type
      
    toggle_type: () =>
      @_commands = @_form.find('.commands')
      if @_types.find('input[value="text"]').attr('checked') == "checked"
        @_body_field.show()
        @_body_field.find('input').removeAttr('disabled')
        @_commands.show()
        @_asset_fields.hide()
        @_asset_fields.find('input').attr('disabled', 'disabled')
      else
        @_asset_fields.show()
        @_asset_fields.find('input').removeAttr('disabled')
        @_commands.hide()
        @_body_field.hide()
        @_body_field.find('input').attr('disabled', 'disabled')

  
  $.fn.bop_block = (space) ->
    @each ->
      new Bop.Block(@, space)


  $.namespace "Bop", (target, top) ->
    target.Block = Block
