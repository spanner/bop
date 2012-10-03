#= require bop/lib/module
#= require bop/lib/rails_glue
#= require bop/admin/menu
#= require_self

$ ->
  $.page_id = $('body').attr('data-bop-page')
  $('#bop_tools').bop_menu()
