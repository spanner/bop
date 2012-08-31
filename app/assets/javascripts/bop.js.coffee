#= require hamlcoffee
#= require bop/lib/parser_rules/advanced
#= require bop/lib/wysihtml5
#= require_tree ./templates
#= require bop/lib/module
#= require bop/lib/bindings
#= require bop/lib/model
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
  $('[data-bop-page]').bop_page()
  $('#boptools').bop_menu()
