#= require bop/module
#= require bop/bindings
#= require bop/model
#= require bop/page
#= require bop/space
#= require bop/block
#= require bop/menu
#= require_self

jQuery ($) ->
  $.easing.glide = (x, t, b, c, d) ->
    -c * ((t=t/d-1)*t*t*t - 1) + b

  $.easing.boing = (x, t, b, c, d, s) ->
    s ?= 1.70158;
    c*((t=t/d-1)*t*((s+1)*t + s) + 1) + b



$ ->
  $('#boptools').bop_menu()
  $('[data-bop-page]').bop_page()
