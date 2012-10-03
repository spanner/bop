#= require jquery
#= require jquery_ujs
#= require bop/lib/module
#= require bop/lib/rails_glue
#= require bop/interface/menu
#= require_self

$ ->
  $.page_id = $('#bop').attr('data-bop-page')
  $('#bop_tools').bop_menu()
