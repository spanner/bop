jQuery ($) ->

  class Page
    constructor: (element) ->
      @_container = $(element)
      @_id = @_container.attr('data-bop-page')
      $.page_id = @_id
      console.log "page!", $.page_id
      @_container.find('[data-bop-space]').bop_space(@)
      
  $.fn.bop_page = ->
    @each ->
      new Bop.Page(@)


  $.namespace "Bop", (target, top) ->
    target.Page = Page
