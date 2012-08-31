jQuery ($) ->
  class Block extends Bop.Model
    @fields ['content', 'block_type', 'markup_type', 'space']
    @label "block"

    place: () =>
      # display default values from template?
      super
      
    display: () =>
      # make contentEditable
      super
      @_editor = $('<a href="#" class="editor">edit</a>').prependTo(@element()).click @edit
      @_remover = $('<a href="#" class="remover">remove</a>').prependTo(@element()).click @destroy
    
    edit: () =>
      @_form = @template('form')
      @_form.find('textarea').attr("id", "textarea_#{@_id}")
      @_form.find('.toolbar').attr("id", "toolbar_#{@_id}")
      @_element.hide().after(@_form)
      @_editor = new wysihtml5.Editor "textarea_#{@_id}",
        stylesheets: ["/assets/application.css", "/assets/bop/wysihtml5.css"],
        toolbar: "toolbar_#{@_id}",
        parserRules: wysihtml5ParserRules

  $.fn.bop_block = (space) ->
    @each ->
      new Bop.Block
        id: $(@).attr('data-bop-block')
        element: @
        space: space
        content: $(@).html()


    
  $.namespace "Bop", (target, top) ->
    target.Block = Block
