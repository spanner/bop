#= require jquery
#= require jquery_ujs
#= require jquery-ui
#= require rangy-core-1.2.3
#= require_tree ../../../../vendor/assets/javascripts/hallo
#= require bop/lib/module
#= require bop/lib/rails_glue
#= require bop/interface/menu
#= require_self

$ ->
  $('#bop_tools').bop_menu()
