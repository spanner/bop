#= require bop/lib/content
#= require_tree ./models/
#= require jquery.autosize-min
#= require_self


# You have to load bop/base separately before you load this file. It is not included automatically
# because there are also cases where we want to load just that file.

jQuery ($) ->
  $.fn.activate = ->
    @find('.error_message').validation_error()
    @find('input[type="submit"]').submitter()
    @    

$ ->
  $('[data-bop-page]').bop_page()
