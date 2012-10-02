#= require bop/lib/codemirror/codemirror
#= require bop/lib/codemirror/xml
#= require bop/lib/codemirror/css
# = require bop/lib/codemirror/javascript
#= require bop/lib/codemirror/coffeescript
#= require bop/lib/codemirror/formatting
#= require bop/lib/codemirror/htmlmixed
#= require bop/lib/codemirror/htmlembedded
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
  $('textarea').code_editor()
  