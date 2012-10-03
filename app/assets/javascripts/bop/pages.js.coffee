#= require bop/lib/jquery.animate-colors
#= require bop/lib/content
#= require_tree ./models/
#= require_self


# You have to load bop/base separately before you load this file. It is not included automatically
# because there are also cases where we want to load just that file.

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
