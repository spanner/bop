#= require jquery
#= require jquery_ujs
#= require bop/lib/module
#= require bop/lib/rails_glue
#= require bop/interface/menu
#= require_self

$ ->
  $('#bop_tools').bop_menu()
