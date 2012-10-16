#= require jquery-ui
#= require bop/lib/jquery.animate-colors
#= require rangy-core-1.2.3
#= require_tree ./bop/lib/hallo
#= require bop/lib/content
#= require_tree ./models/
#= require_self

jQuery ($) ->
  $.fn.activate = ->
    @find('.error_message').validation_error()
    @find('input[type="submit"]').submitter()
    @    

  $.fn.flash = (color, duration) ->
    color ?= "#8dd169"
    duration ?= 1000
    @each ->
      $(@).css('backgroundColor', color).animate({'backgroundColor': '#ffffff'}, duration)

$ ->
  $('[data-bop-page]').bop_page()
  