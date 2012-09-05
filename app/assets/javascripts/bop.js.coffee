#= require hamlcoffee
#= require bop/lib/module
#= require bop/lib/rails_glue
#= require bop/lib/parser_rules/advanced
#= require bop/lib/wysihtml5
#= require bop/lib/codemirror/codemirror
#= require bop/lib/codemirror/css
#= require bop/lib/codemirror/javascript
#= require bop/lib/codemirror/formatting
#= require bop/page
#= require bop/space
#= require bop/block
#= require bop/menu
#= require_self

jQuery ($) ->
  $.easing.glide = (x, t, b, c, d) ->
    -c * ((t=t/d-1)*t*t*t - 1) + b

  $.easing.boing = (x, t, b, c, d, s) ->
    s ?= 1.70158;
    c*((t=t/d-1)*t*((s+1)*t + s) + 1) + b

$ ->
  $('[data-bop-page]').bop_page()
  $('#boptools').bop_menu()
  $('textarea').each () ->
    formatter = $('<a href="#" data-function="autoFormat">Autoformat</a>').insertAfter(@)
    mode = $(@).attr("data-mode")
    editor = CodeMirror.fromTextArea @,
      mode: mode
      lineNumbers: true
      theme: "blackboard"
    $(formatter).click () ->
      from = editor.getCursor(true)
      to = editor.getCursor(false)
      if to.ch == from.ch
        CodeMirror.commands["selectAll"](editor)
        from = editor.getCursor(true)
        to = editor.getCursor(false)
      editor.autoFormatRange(from, to)
      console.log @, from, to
      