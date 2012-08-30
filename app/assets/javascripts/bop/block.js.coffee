jQuery ($) ->
  class Block extends Bop.Model
    @fields ['content', 'block_type', 'markup_type']
    @label "block"


    
  $.namespace "Bop", (target, top) ->
    target.Block = Block
