jQuery ($) ->
  
  class BopMenu
    constructor: (element) ->
      @_container = $(element)
      @_tag = @_container.find('#boptag')
      console.log "BopMenu", @_container, @_tag
      @_showing = @_container.hasClass('showing')
      @_tag.click @toggle
      
    toggle: =>
      if @_showing then @hide() else @show()
    
    show: =>
      @_showing = true
      @_container.animate
        left: 0

    hide: =>
      @_showing = false
      @_container.animate
        left: -600


  $.fn.bop_menu = ->
    @each ->
      new BopMenu(@)


$ ->
  $('#bop').bop_menu()