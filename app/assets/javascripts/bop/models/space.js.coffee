jQuery ($) ->

  class Space extends Bop.Module
    constructor: (element, @_page) ->
      @_container = $(element)
      @_name = @_container.attr('data-bop-space')
      @_container.find('[data-bop-block]').bop_block(@)
      @_adder = $("<a href='#' class='adder'>Add block</a>").appendTo(@_container)
      @_adder.click @addBlock
    
    name: () =>
      @_name
      
    page: () =>
      @_page
      
    addBlock: (e) =>
      e.preventDefault() if e
      block_element = $('<article class="block" />').insertBefore(@_adder).html("<p>Double-click to edit!</p>").bop_block(@)


  $.fn.bop_space = (page) ->
    @each ->
      new Bop.Space(@, page)
  
    
  $.namespace "Bop", (target, top) ->
    target.Space = Space
