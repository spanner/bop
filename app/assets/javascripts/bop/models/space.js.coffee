jQuery ($) ->

  class Space extends Bop.Module
    constructor: (element) ->
      @_container = $(element)
      @_name = @_container.attr('data-bop-space')
      @_container.find('[data-bop-block]').bop_block(@)
      @_adder = $("<div class='holder'><a href='/bop/pages/#{$.page_id}/blocks/new?space=#{@_name}' class='adder' data-remote='true' data-type='html'>Add block</a></div>").appendTo(@_container).remote_link(@addBlock)
      
    element: () =>
      @_container
      
    addBlock: (response) =>
      console.log $(response)
      $(response).hide().insertBefore(@_adder).bop_block(@).slideDown()
      

  $.fn.bop_space = (page) ->
    @each ->
      new Bop.Space(@, page)
  
    
  $.namespace "Bop", (target, top) ->
    target.Space = Space
