jQuery ($) ->

  $.namespace = (target, name, block) ->
    [target, name, block] = [(if typeof exports isnt 'undefined' then exports else window), arguments...] if arguments.length < 3
    top = target
    target = target[item] or= {} for item in name.split '.'
    block target, top

  $.fn.find_including_self = (selector) ->
    selection = @.find(selector)
    selection.push @ if @is(selector)
    selection

  # ## Module
  #
  # This is our base class. It defines utility methods to handle instance collections and bindings, so that all our 
  # classes (including map interface elements, remote models and useful oddments) share the same basic retrieval and
  # trigger mechanisms.
  #
  
  moduleKeywords = ['extended', 'included']

  class Module
    @_callbacks = {}
    @_instances = {}
    @_collection = null

    ## Mixins
    #
    # A bit of boilerplate from the little book. We're not using it at the moment but probably should be.

    @extend: (obj) ->
      for key, value of obj when key not in moduleKeywords
        @[key] = value
      obj.extended?.apply(@)
      this

    @include: (obj) ->
      for key, value of obj when key not in moduleKeywords
        # Assign properties to the prototype
        @::[key] = value
      obj.included?.apply(@)
      this

    ## Collections
    # 
    # As it is loaded, each instance is remembered in two ways: in the `@_instances` lookup hash
    # and in the @_collection observableArray
    # This gives us limited but useful collection-monitoring bahaviour for lists and select boxes.
    #
    # This only works properly with classes that have an #id method.
    #
    @collection: () ->
      @_collection or= new ObservableArray()
    
    @remember: (instance) ->
      if instance.id
        @_instances[instance.id()] = instance
      i = @collection().getArray().indexOf(instance)
      if i+1
        @collection().setAt(i, instance)
      else
        @collection().push(instance)

    @recall: (id) ->
      @_instances[id] if id?


    # ## Default constructor
    #
    # Takes care of instance collection, id, status flags.

    constructor: (data, options) ->
      @is_remote = false
      data ?= {}
      @_id = data['id']
      @klass = @constructor
      @klass.remember @
      

    # ## Instance callbacks
    #
    # Whereas this, which is lifted from spine.js and very little changed, fires instance callbacks.
    # These are much more widely used, eg to propagate commands between objects and to populate
    # and respond to interface elements.
    #
    # Note that yet another kind of callback is defined in Model on an object's associated hasMany collection. 
    # Those also involve MVCArray hooks, but they use them in the same way as instances do here, to trigger callbacks 
    # on the holding object.

    bind: (ev, callback) =>
      console.error('cannot bind nil callback', @, event_name, callback) unless callback?
      evs = ev.split(' ')
      @_callbacks or= {}      
      for event_name in evs
        @_callbacks[event_name] or= []
        @_callbacks[event_name].push(callback)
      @

    #
    unbind: (ev, callback) =>
      unless ev
        @_callbacks = {}
        return this

      list = @_callbacks?[ev]
      return this unless list

      unless callback
        delete @_callbacks[ev]
        return this

      for cb, i in list when cb is callback
        list = list.slice()
        list.splice(i, 1)
        @_callbacks[ev] = list
        break
      this

    trigger: (args...) =>
      ev = args.shift()
      return unless callbacks = @_callbacks?[ev]
      for cb in callbacks
        if cb.apply(this, args) is false
          break
      true

    # ### Collection callbacks 
    #
    # This sets up collection bindings, so that the addition or removal of an item can fire class-level callbacks.
    # They're very simple and only used for updating lists, usually in menus or select boxes.
    #
    # All we do here is hook into the observable properties of the array. The instance callbacks have
    # access to a much more comprehensive event-triggering system.
    #
    @bindCollection: (binder) ->
      binder.bind(@_collection, @_sort_field)


  # ### ObservedArray
  #
  # This is a minimal array with event bindings that mirrors the google MVCArray interface 
  # (except that we call oa.bind rather than setting a map listener, of course).
  #
  class ObservableArray extends Module
    constructor: (arr) ->
      @_array = arr ? []
    
    getArray: () =>
      @_array
      
    insertAt: (i, something) =>
      @_array.splice(i, 0, something)
      @trigger 'insert_at', i, something
      console.log "insert_at", i, something
      something

    setAt: (i, something) =>
      @_array.splice(i, 1, something)
      @trigger 'set_at', i, something
      console.log "set_at", i, something
      something
      
    getAt: (i) =>
      @_array[i]
    
    removeAt: (i) =>
      something = @_array.splice(i, 1)[0]
      @trigger 'remove_at', i, something
      console.log "remove_at", i, something
      something
    
    push: (something) =>
      @insertAt @_array.length, something

    pull: () =>
      @removeAt @_array.length - 1
    
    unshift: (something) =>
      @insertAt 0, something
      
    shift: () =>
      something = @removeAt 0
      




  $.namespace "Bop", (target, top) ->
    target.Module = Module
    target.ObservableArray = ObservableArray
