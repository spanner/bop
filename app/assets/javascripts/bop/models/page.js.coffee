jQuery ($) ->
  class Page extends Bop.Module
    constructor: (element, @_space) ->
      @_container = $(element)
      @_id = @_container.attr('data-bop-page')
      @_container.find('[data-bop-space]').bop_space(@)
      @_container.find('[data-bop-field]').bop_field(@)
    
    id: () =>
      @_id
      
      
  $.fn.bop_page = () ->
    @each ->
      new Bop.Page(@)


  $.namespace "Bop", (target, top) ->
    target.Page = Page
