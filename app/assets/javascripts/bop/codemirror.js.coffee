#= require bop/lib/codemirror/codemirror
#= require bop/lib/codemirror/xml
#= require bop/lib/codemirror/css
#= require bop/lib/codemirror/javascript
#= require bop/lib/codemirror/formatting
#= require bop/lib/codemirror/htmlmixed
#= require bop/lib/codemirror/htmlembedded
#= require_self

jQuery ($) ->
  class CodeEditor
    constructor: (element) ->
      @element = element
      console.log @element
      @formatter = $('<a href="#" data-function="autoFormat">Pretty</a>').insertAfter(@element)
      # @title = 
      @mode = $(@element).attr("data-mode")
      @theme = "fellrace"
      @editor = CodeMirror.fromTextArea @element,
        mode: @mode
        lineNumbers: true
        theme: @theme
      $('body').addClass("cm-s-#{@theme}")
      $(@formatter).bind 'click', () =>
        @format()
              
    format: () =>
      from = @editor.getCursor(true)
      to = @editor.getCursor(false)
      if to.ch == from.ch
        CodeMirror.commands["selectAll"](@editor)
        from = @editor.getCursor(true)
        to = @editor.getCursor(false)
      @editor.autoFormatRange(from, to)
      
  $.fn.code_editor = ->
    @each ->
      new CodeEditor(@)

$ ->
  $('textarea').code_editor()
  