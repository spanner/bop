#= require bop/module
#= require hamlcoffee
#= require_tree ./templates
#= require remote_model/model
#= require remote_model/bindings
#= require_tree ./bop/models

jQuery ($) ->
  $.easing.glide = (x, t, b, c, d) ->
    -c * ((t=t/d-1)*t*t*t - 1) + b

  $.easing.boing = (x, t, b, c, d, s) ->
    s ?= 1.70158;
    c*((t=t/d-1)*t*((s+1)*t + s) + 1) + b

  class BopMenu
    constructor: (element) ->
      @_container = $(element)
      @_tag = @_container.find('.boptag')
      @_tree = @_container.find('.pagetree')
      @_showing = @_container.hasClass('showing')
      @_tag.click @toggle
      @_closed_state = 
        left: @_tag.width() - @_container.width()
        bottom: @_tag.height() - @_container.height()
      @_open_state = 
        left: 0
        bottom: 0
      
    toggle: =>
      if @_showing then @hide() else @show()
    
    show: =>
      @_showing = true
      @_container.addClass('showing').animate @_open_state, 'slow', 'glide'

    hide: =>
      @_showing = false
      @_container.animate @_closed_state, 'fast', 'glide', () =>
        @_container.removeClass('showing')

  $.fn.bop_menu = ->
    @each ->
      new BopMenu(@)


$ ->
  $('#bop').bop_menu()
