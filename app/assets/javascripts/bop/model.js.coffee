# This is designed to serve as the minimal front-end reflection of a rails model class. It combines
# the fetch/update/save transparency of backbone.js with the dom-binding immediacy of knockout.js,
# in each case with a minimal feature set meant to do no more than we need, and it adds a rails-like 
# system of associations that can be loaded, saved and bound through simple named-method calls. 
#
# The remote model is designed to sit in front of a standard rails REST API. It can read and write
# nested attributes and foreign-key fields, populating and updating associated instances automatically.
#
# Our design goal is to provide a completely sane, logical, conventional chain of connections from 
# the DOM element to the rails model, and to do it in less than 500 LOC. There is still some way to go.
#
# There are several kinds of work going on here:
#
# * Collection-handling and a universal callback system are provided by the `Module` base class in core.js
# * RESTing is handled by the Model class here, which is the base for all our model classes.
# * DOM-binding is handled by a mixed bag of jquery and OO code in `binding.js
# * Map-interface primitives are defined in `map_interface.js` and bound to callbacks in our model classes.
#
jQuery ($) ->

  ## Remote Models
  #
  # Remote models are a thin and fairly dumb extension into the foreground of your Rails models. The usual 
  # structure of a remote model is like this:
  #
  #   class Widget extends Model
  #     ...declare properties
  #     ...override and extend as required
  #
  # Most interaction between models can be handled by declaring associations and binding callbacks, of which 
  # much more below.
  #
  # By inheriting from the base Module class we get standard callback-binding and collection-maintenance.
  #
  class Model extends Bop.Module
    @_klasses = {}
    @_observers = []
    @_fields = ['id']
    @_associations = []
    @_dependencies = []
          
    # ### Model class properties
    #
    # *label(key)*
    #
    # Sets or gets the model classname. Usually looks like this:
    #
    #   class Widget
    #     @name 'widget'
    #
    # This is required. It ought to be automatic and one day it might be, but javascript isn't good at this kind 
    # of introspection.
    #
    @label: (key) ->
      if key?
        @_singular = key
        @_plural = "#{key}s"    #!
        @_klasses[key] = @
      @_singular

    # *plural(key)*
    #
    # Plurals are normally handled just by appending an 's'. You can override that by supplying a 
    # better plural form:
    #
    #   class Tardis
    #     @name 'tardis'
    #     @plural 'tardii'
    #
    # #todo: this doesn't really work at the moment: needs a reverse lookup table.
    #
    @plural: (key) ->
      if key?
        @_plural = "#{key}s"    #!
      @_plural
    
    # *fields([keys])*
    #
    # Defines the basic attribuets of a class. These are your data columns in rails. They can be accessed through the 
    # generic `get` and `set` methods, and we also define named accessors for each field. In either case, setting the
    # field will trigger `set_[field_name]` callbacks.
    #
    #   class Adversary
    #     @name 'adversary'
    #     @fields ['name', 'goal']
    #
    # in which case these calls are the same:
    #
    #   adversary.name("Scaramanga")
    #   adversary.set('name', "Scaramanga")
    #
    # and either will trigger any 'set_name' callbacks defined on the adversary object.
    #
    @fields: (keys) ->
      @_fields = $.merge ['id'], keys
      @attr_accessor(key) for key in keys
    
    # *belongsTo([keys])*
    #
    # You may want to mirror some of your belongs_to associations here, so that compound data can be managed either in 
    # pieces or as a bundle of related items. Same syntax as elsewhere:
    #
    #   class Adversary
    #     @name 'adversary'
    #     @fields ['name', 'goal']
    #     @belongsTo ['galaxy', 'category']
    #
    # Accessors are defined exactly as for simple fields, except that they expect and return model objects.
    #
    @belongsTo: (keys) ->
      # nb. @_associations here is the class property: it lists associates that might be present in an instance
      @_associations = keys
      @attr_accessor(key) for key in keys
  
    # *hasMany([keys])*
    #
    # Has_many associations can be brought into the foreground in the same way::
    #
    #   class Adversary
    #     @name 'adversary'
    #     @fields ['name', 'goal']
    #     @hasMany ['henches']
    #
    # Accessors are defined exactly as for simple fields, except that they expect and return lists of model objects.
    #
    @hasMany: (keys) ->
      # nb. @_dependencies here is the class property: it lists has_many associates that might be present in an instance
      @_dependencies = keys
      @attr_accessor(key) for key in keys
    
    @attr_accessor: (key) ->
      @::[key] ?= (value) ->
        @set(key, value) if value?
        @get(key)

    # *sortBy(field)*
    #
    # Determines the order in which instances are presented.
    #

    @sortBy: (field) ->
      @_sort_field = field
    
    
    # ### Model class administration
    #
    # We often need to move between class names and model classes (eg when declaring an association
    # or binding to a DOM node). The translations from string to function and back are all handled here,
    # as determined by the `name` and `plural` declarations.
    #
    # klassFor('adversary') will return the Adversary class object, so this would be allowed:
    #
    #   new klassFor('adversary')()
    #
    @klassFor: (key) ->
      @_klasses[key]

    # klassForPlural() performs the same operation but takes the plural form as argument. Some situations
    # (eg dom-binding a collection) are naturally plural and read better in this form.
    #
    # #todo: check against a _plurals hash before just lopping off the s$.
    #
    @klassForPlural: (key) ->
      @_klasses[key.replace(/s$/,'')]
    
    
    # ### Fetching and saving
    #
    # Override the url method if your model has a special API scheme. This is not currently configurable 
    # but it will be.
    #
    @url: ->
      "/bop/pages/#{$.page_id}/#{@_plural}"

    # As in rails, build will return a new, unpersisted object of this class.
    @build: () ->
      instance = new @ 
        name: "new #{@_singular}",
        title: "new #{@_singular}"
    
    # Class-fetch retrieves all objects of this class from the API. This is usually done during interface
    # construction, so you can supply a specific callback that will be called when loading is complete.
    #
    @fetch: (callback) ->
      $.ajax 
        url: @url()
        dataType: 'json'
        error: @xhr_error
        success: (response) =>
          $.each response, (i, item) =>
            @.get item
          callback?()

    # This is `get` as in singleton get: all our instance-retrieval calls are routed through this method
    # to ensure that we carry only one copy of each.
    #
    @get: (data) ->
      if data?
        # If it's already an instance, just return it.
        if typeof data is "object" and data.className?() is @_singular
          data
        else
          # if it's not an object at all, probably just an id
          data = {id: data} unless typeof data is "object"
          if instance = @recall(data.id)
            instance.refresh(data)
          else
            new @ data

    # ### Class display
    #
    # You can call show, hide open or close on the class to pass that instruction to all of its instances.
    #
    @show: () ->
      $.each @_collection, (i, instance) ->
        instance.show()
    
    @hide: () ->
      $.each @_collection, (i, instance) ->
        instance.hide()

    @open: () ->
      @_collection.forEach (instance) ->
        instance.open()

    @closeAll: () ->
      @_collection.forEach (instance) ->
        instance.close()

    # All our ajax errors end up here.
    #
    @xhr_error: (jqXHR, textStatus, errorThrown) =>
      console.error "Ajax class failure in #{@name}: #{textStatus}, #{errorThrown}"


    # ## Instance methods
    #
    # The constructor here sets up the shell of an object but it is the refresh method below that does most
    # of the work of populating it. Here we just define initial state and make a note of the object.
    #
    constructor: (data, options) ->
      @is_remote = true
      data ?= {}
      @_id = data['id']
      @_observers = []
      @_open = false
      @_showing = false
      @klass = @constructor
      @refresh(data)
      @klass.remember @
      if @persisted
        @display()
      else
        @place()
    
    # Id is the only required field. In an new object it will be a guid until it is saved and the server returns
    # a persisted id.
    #
    id: () =>
      @_id ?= $.makeGuid()

    # *className* returns the singular name of the class of this instance.
    #
    className: =>
      @klass._singular
      
    # *pluralName* returns the plural name of the class of this instance.
    #
    pluralName: =>
      @klass._plural

    # *resourceUrl* returns the url of this instance, which is derived from the class url and the instance id in 
    # the usual rails way. This is the address used to fetch and update this object once/if it has been saved.
    #
    resourceUrl: () =>
      "#{@klass.url()}/#{@_id}"
    
    # This is a hard reset that you are very unlikely to want.
    #
    revert: () =>
      @refresh @source_data
    
    # `refresh` is our central set-from-server method. Whenever the server returns a representation of this object,
    # which happens after saving as well as on initial fetch and may soon be pushed to us, the data is passed through
    # this method to update the object and all of its bindings.
    # 
    refresh: (data) =>
      if data?
        @source_data = data
      
        # Here we may be overwriting a temporary id with a real one.
        @_id = data.id
        delete data.id
        @persisted = @_id?
      
        # Associates and attributes are prepared.
        @_attributes ?= {}
        @_associates ?= {}
        @_dependents ?= {}
    
        # If we've only been given an ID, data will be be empty now.
        # In that case, existing data is preserved. If none is present
        # we go and get it.
        # Note that the fetch call will come back round to refresh
        # again, but that time with data.
        if @persisted and not Object.keys(data).length and not Object.keys(@_attributes).length
          @fetch()
      
        # Otherwise, we assume that what we've been given is everything we need.
        else
          for key, value of data
            @set key, value
        @

    # Calling *fetch* on an instance triggers a request to the server for its full representation. The returned data
    # will be passed to `instance.refresh` to update the local representation, which at this stage might be stale, 
    # deleted or just an associated id.
    #
    fetch: (options) =>
      if @persisted?
        $.ajax 
          url: @resourceUrl()
          dataType: 'json',
          type: 'GET',
          error: @constructor.xhr_error
          success: (response) =>
            @refresh(response)
      @

    # *data* returns a representation of this object suitable for passing back to the API in save. It does the right thing
    # with associated data, as far as Rails is concerned, and you shouldn't really need to bother with it.

    data: () =>
      params = @_attributes
      params['id'] = @_id if @persisted
      for key, associate of @_associates
        if associate.persisted
          params["#{key}_id"] = associate.id()
        else
          params["#{key}_attributes"] = associate.data()

      for key, dependents of @_dependents
        params["#{key}_attributes"] = $.map dependents.getArray(), (dep) ->
          dep.data()
      params
      
    # Calling *save* on an instance sends it back to the API as either an update or (if we are new) a create request.
    # Returned data is passed through `refresh` to update the local representation.
      
    save: =>
      payload = {}
      payload[@className()] = @data()
      if @persisted
        url = @resourceUrl()
        payload['_method'] = "PUT"
      else
        url = @klass.url()

      $.ajax
        url: url
        dataType: 'json'
        type: 'POST'
        data: payload
        error: @ajaxError
        success: @refresh
      @

    # Calling *destroy* does what you'd expect. If an object is persisted it sends a delete request to the API then removes
    # its local representation, which will cause the removal of any associated DOM nodes.

    destroy: =>
      if @persisted?
        $.ajax
          url: @resourceUrl()
          dataType: 'json'
          type: 'POST'
          data:
            id: @_id
            _method: "DELETE"
          error: @ajaxError
          success: @remove
      else
        @remove()

    # This is called after a successful save and can be used to signal success.
    confirm: (response, textStatus, jqXHR) =>
      console.log "...saved", response
      return

    # This is called after a successful save and can be used to signal success.  
    ajaxError: (jqXHR, textStatus, errorThrown) =>
      console.log "...error!", jqXHR, textStatus, errorThrown
      trigger "error", textStatus, errorThrown
      return

    # ## Mutators
    #
    # Pretty much everything else we do is channelled through these and get and set methods. Somebody should document 
    # them properly.
    #
    
    get: (key) =>
      if @constructor._fields.indexOf(key) isnt -1
        @_attributes[key]
      else if @constructor._associations.indexOf(key) isnt -1
        @_associates[key]
      else if @constructor._dependencies.indexOf(key) isnt -1
        @_dependents[key]

    set: (key, value) =>
      if @constructor._fields.indexOf(key) isnt -1
        @_attributes[key] = value
        
      else if @constructor._associations.indexOf(key) isnt -1
        associate = Model.klassFor(key).get(value)
        @_associates[key] = associate
        
      else if @constructor._dependencies.indexOf(key) isnt -1
        unless @_dependents[key]?
          @_dependents[key] = new google.maps.MVCArray
          google.maps.event.addListener @_dependents[key], "insert_at", (i) =>
            @trigger "add_#{key}", i
          google.maps.event.addListener @_dependents[key], "remove_at", (i) =>
            @trigger "remove_#{key}", i
          google.maps.event.addListener @_dependents[key], "set_at", (i) =>
            @trigger "set_#{key}", i
          
        @_dependents[key].clear()
        klass = Model.klassForPlural(key)
        $.each value, (i, associate) =>
          associate = klass.get(associate) unless associate.klass? is klass
          associate.set @className(), @
          @_dependents[key].push associate
          
      @trigger "set_#{key}"
      value
      
    # Calling `bindProperty(element)` causes a sort of notification of status: when the object is shown or hidden 
    # the element is updated according. When the object is removed, so is the element. If a property 
    # argument is given, we also bind updates of that property and update it now to populate the element.
    #
    bindProperty: (element, property, attribute) =>
      @bindAppearance element
      if property?
        observer = $(element)
        @bind "set_#{property}", =>
          observer.updateWith attribute, @get(property)
        observer.updateWith attribute, @get(property)

    bindAction: (element, action, eventname) =>
      @bindAppearance element
      if action?
        $(element).bind eventname, @[action]

    bindAppearance: (element) =>
      observer = $(element)
      @_observers.push element
      @bind "wait", =>
        observer.addClass('waiting')
      @bind "unwait", =>
        observer.removeClass('waiting')
      
    # *bind_to* creates a tight linkage between this and the supplied foreign object. All our abstract interface events
    # (show, hide, etc) are relayed to the foreign object and a click on that object is relayed back to us. use it when you have
    # an interface element (eg map area and you want to make a click there the same as a click here).
    #
    # Abstract events (show, hide) are passed down. Concrete events (click, drag) are passed up. You very rarely want to call 
    # click_me directly.
    #
    bind_to: (foreign_object) =>
      if foreign_object?
        @bind "open", foreign_object.open
        @bind "close",foreign_object.close
        @bind "show", foreign_object.show
        @bind "hide", foreign_object.hide
        # we take their click. A ha.
        foreign_object.bind "click", @click_me

    # Here's an important detail. You can always call @click_me to trigger a click event on this object. It never does anything else. 
    # You never click_me during a click event on this object, and you never bind click_me to the click event, or a very tight loop will
    # immediately follow.
    #
    # To achieve an effect on click, bind a callback to the click event. 
    #
    click_me: (e) => 
      @trigger "click", e, @
    
    # *display* is called upon successful population of an object. It is a hook commonly used in subclasses to 
    # set up interface elements and other ephemera. By default it just shows the object.
    #
    display: () =>
      @show()

    #
    # ### Instance templates
    #
    # We are using standard JST templates, written in haml_coffee and held under a `Templates` namespace with the convention
    # that each model class lives in its own subdirectory. To render the standard list item template for your class, just call:
    #
    #     instance.template('li')
    #
    # This will call 
    #
    #     Templates['class_name/li'](data)
    #
    # Where the data object is a very basic (and entirely passive) ViewModel representation of your instance. 
    # The resulting html is passed through `activate` to enable standard interface elements and then through `set_bindings`
    # to set up collection and instance bindings. We return the activated html and expect the caller to put it somewhere
    # on the page.
    #
    # NB Mike: this requires the haml_coffee_assets gem and a set of template .hamlc files in /app/assets/javascripts/templates/
    #
    template: (filename) =>
      if Templates["#{@pluralName()}/#{filename}"]?
        tpl = $(Templates["#{@pluralName()}/#{filename}"](@templateData()))
        tpl = tpl.activate()
        tpl = tpl.set_bindings(@)
        tpl
    
    # *templateData* returns a minimal representation of this object suitable for populating a template. In most cases
    # you'll want to bind values rather than writing them into the page, so this doesn't get much use.
    #
    templateData: () =>
      $.extend {}, @_attributes, @_associates,
        id: @_id

    # This is called immediately after a new instance is built.
    # It is generally used to set up listeners that will locate the new item on the map and show its editing form.
    place: () =>
      @trigger "place", @

    # ### Instance display
    #
    # Just your basic toggle switches. Show/hide controls the visibility of the object at all. Open/close controls the state
    # of the object, which expands to show either its editing apparatus or a fuller representation. Often both are the same.
        
    showOrHide: (e) =>
      e.preventDefault() if e
      if @_showing then @hide() else @show()

    show: (e) =>
      e.preventDefault() if e
      $(@_observers).addClass('showing')
      @_showing = true
      @trigger "show"
      @

    hide: (e) =>
      e.preventDefault() if e
      $(@_observers).removeClass('showing')
      @_showing = false
      @close()
      @trigger "hide"
      @

    openOrClose: (e) =>
      e.preventDefault() if e and e.preventDefault
      if @_open then @close(e) else @open(e)
      @
      
    open: (e) =>
      e.preventDefault() if e and e.preventDefault
      @_open = true
      @trigger "open"
      @
      
    close: (e) =>
      e.preventDefault() if e and e.preventDefault
      @_open = false
      @trigger "close"
      @

    # *remove* gets rid of this object, its observing dom elements and (through callbacks) any associates set up also to go.
    #
    remove: (e) =>
      e.preventDefault() if e
      $(@_observers).remove()
      @trigger "delete"
      delete @
      @

    # wait/unwait is passed back to obsevers.
    #
    wait: () =>
      @trigger "wait"
      @
      
    unwait: () =>
      @trigger "unwait"
      @


  # minimal rfc4122 generator taken from http://stackoverflow.com/questions/105034/how-to-create-a-guid-uuid-in-javascript
  $.makeGuid = ()->
    'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace /[xy]/g, (c) ->
      r = Math.random()*16|0
      v = if c is 'x' then r else r & 0x3 | 0x8
      v.toString 16



  $.namespace "Bop", (target, top) ->
    target.Model = Model
