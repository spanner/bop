jQuery ($) ->
  class Block extends Bop.RemoteModel
    @_instances: {}
    @_collection: null
    @_observers: []
    @label "block"
    @fields ['name', 'content', 'markup_type', 'block_type']
    # @belongsTo ['page']
    # @hasUpload ['image']
    @sortBy 'name'
    
  $.namespace "Bop", (target, top) ->
    target.Block = Block
