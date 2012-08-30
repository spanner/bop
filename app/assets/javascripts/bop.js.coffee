#= require bop/module
#= require bop/bindings
#= require bop/model
#= require bop/block
#= require bop/menu

jQuery ($) ->
  $.easing.glide = (x, t, b, c, d) ->
    -c * ((t=t/d-1)*t*t*t - 1) + b

  $.easing.boing = (x, t, b, c, d, s) ->
    s ?= 1.70158;
    c*((t=t/d-1)*t*((s+1)*t + s) + 1) + b

  $.fn.bop_menu = ->
    @each ->
      new Bop.Menu(@)
  
  $.fn.bop_block = ->
    @each ->
      $(@).set_bindings new Bop.Block
        id: $(@).attr('data-bop-block')


$ ->
  $.page_id = $('[data-bop-page]').attr('data-bop-page')
  $('#boptools').bop_menu()
  $('[data-bop-block]').bop_block()
