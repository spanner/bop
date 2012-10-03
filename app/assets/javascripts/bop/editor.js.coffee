#= require bop/base
#= require_tree ./lib/codemirror
#= require_self

jQuery ($) ->
  class CodeEditor
    constructor: (element) ->
      @area = element
      @prettifier = $('<a href="#" data-function="autoFormat">Pretty</a>').insertAfter(@area)
      @mode = $(@area).attr("data-mode")
      @theme = "fellrace"
      @formats = $('.formats')
      @type = $(@area).attr("data-mode")
      @format = @formats.find('input[checked="checked"]').val() || @type
      @editor = CodeMirror.fromTextArea @area,
        mode: @format
        lineNumbers: true
        theme: @theme
      @formats.find('input').bind "change", @change_format
      $('body').addClass("cm-s-#{@theme}")
      $(@prettifier).bind 'click', () =>
        @prettify()
      
    prettify: () =>
      from = @editor.getCursor(true)
      to = @editor.getCursor(false)
      if to.ch == from.ch
        CodeMirror.commands["selectAll"](@editor)
        from = @editor.getCursor(true)
        to = @editor.getCursor(false)
      @editor.autoFormatRange(from, to)
      
    change_format: (e) =>
      @format = $(e.target).val()
      @editor.setOption("mode", @format)
      
  $.fn.code_editor = ->
    @each ->
      new CodeEditor(@)

$ ->
  $('#bop_tools').bop_menu()
  $('textarea').code_editor()
