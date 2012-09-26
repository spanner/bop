#= require jquery
#= require jquery_ujs
#= require bop/lib/module
#= require bop/lib/rails_glue
#= require bop/menu
#= require bop/template
#= require bop/pagetree
#= require_self

jQuery ($) ->
  $.easing.glide = (x, t, b, c, d) ->
    -c * ((t=t/d-1)*t*t*t - 1) + b

  $.easing.boing = (x, t, b, c, d, s) ->
    s ?= 1.70158;
    c*((t=t/d-1)*t*((s+1)*t + s) + 1) + b

  $.add_stylesheet = (path) ->
    if document.createStyleSheet
      document.createStyleSheet(path)
    else
      $('head').append("<link rel=\"stylesheet\" href=\"#{path}\" type=\"text/css\" />");

$ ->
  $.page_id = $('body').attr('data-bop-page')
  $('#bop_tools').bop_menu()
