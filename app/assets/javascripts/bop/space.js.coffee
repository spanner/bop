jQuery ($) ->

  class Space
    constructor: (element, @_page) ->
      @_container = $(element)
      @_name = @_container.attr('[data-bop-space]')
      @_container.find('[data-bop-block]').bop_block(@)
      @_adder = $('<a href="#" class="adder">Add block</a>').appendTo(@_container).click(@addBlock)
      
    addBlock: =>
      block = new Bop.Block
        space: @
      @_adder.before(block.element())
      

  $.fn.bop_space = (page) ->
    @each ->
      new Bop.Space(@, page)
  
    
  $.namespace "Bop", (target, top) ->
    target.Space = Space
