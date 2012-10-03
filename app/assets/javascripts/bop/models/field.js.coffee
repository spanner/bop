jQuery ($) ->
  class Field extends Bop.Module
    constructor: (element, @_page) ->
      @_container = $(element)
      @_fieldname = @_container.attr('data-bop-field')
      @_content = new Bop.Content @_container, @save
      
    save: (content) =>
      console.log "field save", @_fieldname, @_page, content
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
      # get json back, set id if new
      

    error: (a, b, c) =>
      console.log "Block save error", a, b, c
      
      
    
  $.fn.bop_field = (space) ->
    @each ->
      new Bop.Field(@, space)


  $.namespace "Bop", (target, top) ->
    target.Field = Field
