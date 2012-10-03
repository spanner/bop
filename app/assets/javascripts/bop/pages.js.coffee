#= require bop/lib/rails_glue
#= require bop/lib/parser_rules/advanced
#= require bop/lib/wysihtml5
#= require bop/lib/content_editable
#= require_tree ./models/
#= require jquery.autosize-min
#= require_self

jQuery ($) ->
  $.fn.activate = ->
    @find('.error_message').validation_error()
    @find('input[type="submit"]').submitter()
    @    

  class Editor
    constructor: (element) ->
      @_container = $(element)
      @_original_textarea = @_container.find('textarea')
      @_toolbar = @_container.find('.toolbar')
      @_toolbar.attr('id', $.makeGuid()) unless @_toolbar.attr('id')?
      @_original_textarea.attr('id', $.makeGuid()) unless @_original_textarea.attr('id')?
      console.log @_original_textarea.attr('id')
      @_stylesheets = ["/assets/bop.css", "/assets/bop/wysi_iframe.css"]
      $.each $("head link[data-wysihtml5='custom_css']"), (i, link) =>
        @_stylesheets.push $(link).attr('href')
      @_editor = new wysihtml5.Editor @_original_textarea.attr('id'),
        stylesheets: @_stylesheets,
        toolbar: @_toolbar.attr('id'),
        parserRules: wysihtml5ParserRules,
        useLineBreaks: false
      @_toolbar.show()
      @hideToolbar()
      @_original_textarea.autosize()
      @_editor.on "load", () =>
        @_iframe = @_editor.composer.iframe
        @_iframe_body = $(@_editor.composer.doc).find('body')
        @_textarea = @_editor.composer.element
        @resizeIframe()
        @_textarea.addEventListener("keyup", @resizeIframe, false)
        @_textarea.addEventListener("blur", @resizeIframe, false)
        @_textarea.addEventListener("focus", @resizeIframe, false)
        @_container.bind("mouseenter", @showToolbar)
        @_container.bind("mouseleave", @hideToolbar)
        
    resizeIframe: (e) =>
      e.preventDefault() if e
      console.log @_editor.composer, @_textarea.clientHeight
      if $(@_iframe).height() != @_textarea.clientHeight
        if @_textarea.offsetHeight > 19
          $(@_iframe).height @_textarea.clientHeight
        else $(@_iframe).height 19
    
    showToolbar: () =>
      @_hovered = true
      @_toolbar.fadeTo(200, 1)
    
    hideToolbar: () =>
      @_hovered = false
      @_toolbar.fadeTo(1000, 0.2)

  $.fn.html_editable = ()->
    @each ->
      editor = new Editor @

$ ->
  $.page_id = $('body').attr('data-bop-page')
  $('[data-bop-space]').bop_space()
  $('#bop_tools').bop_menu()
  $('.contenteditable').bop_content()
