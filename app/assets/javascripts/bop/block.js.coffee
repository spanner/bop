jQuery ($) ->
  class Block extends Bop.Model
    @fields ['content', 'block_type', 'markup_type', 'space']
    @label "block"

    place: () =>
      # display default values from template?
      super
      console.log "new block placed", @

    display: () =>
      # make contentEditable
      super
      console.log "new block displayed"


  $.fn.bop_block = (space) ->
    @each ->
      $(@).set_bindings new Bop.Block
        id: $(@).attr('data-bop-block')
        space: space


    
  $.namespace "Bop", (target, top) ->
    target.Block = Block
