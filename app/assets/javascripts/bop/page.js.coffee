jQuery ($) ->

  class Page extends Bop.Module
    constructor: (element) ->
      @_container = $(element)
      @_id = @_container.attr('data-bop-page')
      $.page_id = @_id
      @_container.find('[data-bop-space]').bop_space(@)
      
    element: () =>
      @_container



  $.fn.bop_page = ->
    @each ->
      console.log "page!", $(@)
      new Bop.Page(@)


  $.namespace "Bop", (target, top) ->
    target.Page = Page
