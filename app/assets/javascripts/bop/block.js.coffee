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
      @_element.hide().after(@_form)

  $.fn.bop_block = (space) ->
    @each ->
      new Bop.Block
        id: $(@).attr('data-bop-block')
        element: @
        space: space


    
  $.namespace "Bop", (target, top) ->
    target.Block = Block
