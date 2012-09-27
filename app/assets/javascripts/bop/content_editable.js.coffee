jQuery ($) ->
  class Content extends Bop.Module
    constructor: (element) ->
      @_container = $(element)
      @show()

    replaceProvisionallyWith: (element) =>
      new_container = $(element)
      @_original_container = @_container
      @_container.after(new_container).hide()
      @_container = new_container
      @_container.find('a.cancel').click(@revert)
      
    replaceWith: (element) =>
      new_container = $(element)
      @_container.after(new_container).remove()
      @_container = new_container
      
    revert: (e) =>
      e.preventDefault() if e
      unless @_container is @_original_container
        @_container.remove() 
        @_container = @_original_container
      @_container.show()

    show: () =>
      @_container.removeClass('editing')
      @_controls = $('<div class="controls" />').prependTo(@_container)
      @_editor = $("<a href='/bop/pages/#{$.page_id}/edit.js' class='editor icon' data-remote='true' data-type='html'>edit</a>").appendTo(@_controls).remote_link(@edit)

    edit: (response) =>
      @replaceProvisionallyWith(response)
      @_form = @_container.find('form')
      @listen()
      @_form.remote_form(@update)
      @_container.addClass('editing')
      
    listen: () =>
      @_field = @_form.find('[data-field="title"]')
      @_area = @_form.find('#pagetitle')
      @transfer()
      
    transfer: () =>
      @_area
        .bind 'focus', =>
          @_area.data 'before', @_area.html()
          @_area
        .bind 'blur keyup paste', =>
            if @_area.data('before') isnt @_area.html()
                @_area.data 'before', @_area.html()
                @_area.trigger('change')
            @_field.val(@_area.text().trim())
          
      
    update: (response) =>
      @replaceWith(response)
      @show()
      
  $.fn.bop_content = (space) ->
    @each ->
      new Bop.Content @


  $.namespace "Bop", (target, top) ->
    target.Content = Content
