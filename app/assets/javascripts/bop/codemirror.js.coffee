#= require bop/lib/codemirror/codemirror
#= require bop/lib/codemirror/css
#= require bop/lib/codemirror/javascript
#= require bop/lib/codemirror/formatting
#= require_self

$ ->
  $('textarea').each () ->
    formatter = $('<a href="#" data-function="autoFormat">Autoformat</a>').insertAfter(@)
    mode = $(@).attr("data-mode")
    editor = CodeMirror.fromTextArea @,
      mode: mode
      lineNumbers: true
      theme: "ambiance"
    $(formatter).click () ->
      from = editor.getCursor(true)
      to = editor.getCursor(false)
      if to.ch == from.ch
        CodeMirror.commands["selectAll"](editor)
        from = editor.getCursor(true)
        to = editor.getCursor(false)
      editor.autoFormatRange(from, to)
