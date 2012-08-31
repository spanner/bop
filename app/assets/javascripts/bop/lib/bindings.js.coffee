# This is minimal binding regime. It binds elements to objects and to collections of objects, such that when 
# the properties of the object change or the members of the collection change, our element is automatically 
# updated. It will also create reciprocal links from editable elements so that the bound object is updated
# when they change, and it can bind object methods to interface events.
# 
# This all works in a very similar way to knockout.js, but with much less configurability and no inline code.
# It is essentially declarative, and gives you only three simple calls to make:
#
#   <ul data-bind-collection="poi_types"></ul>
#   <h3 data-bind="value: name"></h3>
#   <a data-bind-action="click: doSomething">...</a>
#
# In most cases this will take place during template preparation, so there will always be an object in the 
# foreground doing the templating. it is that object that we bind to. In the case of collection-bindings the 
# object is not essential and you can also create those bindings in a rails view. That's how we set up the
# main interface lists.

jQuery ($) ->

  $.fn.find_including_self = (selector) ->
    selection = @.find(selector)
    selection.push @ if @is(selector)
    selection

  # *set_bindings* is called during template preparation and given the calling object as first argument.
  # During initial page constructionto set also make a direct call to `$('[data-bind-collection]').bind_collection`.
  #
  $.fn.set_bindings = (object) ->
    @find('[data-bind-collection]').bind_collection(object)
    if object
      @find_including_self('[data-bind]').bind_values(object)
      @find_including_self('[data-action]').bind_actions(object)
    else
    @
    
  # ## Binding a container to a collection
  
  # Collection-binding is simple and conventional, with very little configuration involved. A remote model class
  # can be observed by a list or select box: whenever an instance of that class is added, removed or replaced, that
  # part of the view is refreshed. The individual list items (or options) are each bound to their instance, so 
  # changes within the instance are reflected without affecting the containing list.
  #
  # The syntax is minimal:
  #
  #   <ul data-bind-collection="poi_types"></ul>
  #
  
  class CollectionBinding
    constructor: (klassname, @container, @object) ->
      @_children = new google.maps.MVCArray()
      @_collection = null
      @_sort_field = null
      @klass = Bop.Model.klassFor(klassname)
      @bind @klass
      @render()
      # After the render so that the value can be set
      if @object? and @container.is('select')
        @container.bind_values @object, "value: #{klassname}"
    
    bind: (klass) =>
      @_collection = klass.collection()
      @_sort_field = klass._sort_field
      google.maps.event.addListener @_collection, 'insert_at', @insertAt
      google.maps.event.addListener @_collection, 'set_at', @setAt
      google.maps.event.addListener @_collection, 'remove_at', @removeAt
    
    render: () =>
      @_collection.forEach (instance) =>
        if newchild = instance.template @tagname()
          @_children.push newchild
          @container.append newchild

    insertAt: (i) =>
      instance = @_collection.getAt(i)
      element = @_children.getAt(i)
      if newchild = instance.template @tagname()
        @_children.insertAt i, newchild
        if element
          element.after(newchild)
        else
          @container.append(newchild)
    
    setAt: (i) =>
      instance = @_collection.getAt(i)
      element = @_children.getAt(i)
      if newchild = instance.template @tagname()
        @_children.setAt i, newchild
        element.replaceWith newchild

    removeAt: (i) =>
      element = @_children.getAt(i)
      @_children.removeAt i
      element?.remove()

    tagname: () =>
      switch @container[0].tagName
        when "SELECT" then "option"
        when "UL" then "li"
      
    
    
  $.fn.bind_collection = (object, klassname) ->
    @each ->
      observer = $(@)
      boundKlass = klassname ? observer.attr('data-bind-collection').replace(/s$/,'')
      new CollectionBinding(boundKlass, observer, object)
    @

  # ## Binding attributes to object properties
  
  # Object-binding is more configurable, but still within conventions. These bindings can only be used in
  # templates, where there will always be a foreground object. We can only bind to that object, but 
  # through its associations we can also get to related instances and collections.
  #
  # The syntax is like this:
  #
  #   <element data-bind="attribute: property" />
  #
  # So to bind the value of a text field to the name of our current object:
  #
  #   <input type="email" data-bind="value: email" />
  #
  # This will automatically populate the email field and keep it up to date with changes made elsewhere. 
  # In the case of editable elements like this text field, most other form elements or (soon) to any html5 
  # contentEditable block, changes made here will be pushed back immediately to the bound object.
  #
  # NB. We update but do not save the bound object, Its other representations will change locally, but not
  # on the server side until you trigger a save, which would usually be from a submit button.
  #
  # The usual bindings are text and value, but you can bind any attribute that jQuery will set to any property 
  # that your object will get and set. 
  #
  # ### Binding associates
  #
  # In theory (and the whole reason this exists) you can also bind associated objects and collections. 
  # Syntax for that I haven't sorted out yet.
  #
  $.fn.bind_values = (object, binds) ->
    @each ->
      observer = $(@)
      bindings = binds ? observer.attr('data-bind')

      observer.attr('data-bind', null)
      for binding in bindings.split(/;\s*/)
        [attribute, property] = binding.split(/:\s+/)
        
        # get attributes from object
        object.bindProperty @, property, attribute
        observer.updateWith attribute, object.get(property)
        
        # send attributes to object, if we're editable
        switch @tagName
          when "INPUT", "TEXTAREA"
            observer.bind 'keyup', (e) ->
              kc = e.which
              #   delete,     backspace,    alphanumerics,    number pad,        punctuation
              if (kc is 8) or (kc is 46) or (47 < kc < 91) or (96 < kc < 112) or (kc > 145)
                object.set property, observer.val()
            observer.bind 'change', (e) ->
              console.log "changed"
              object.set property, observer.val()
              
          when "SELECT"
            observer.bind 'change', (e) ->
              object.set property, observer.val()
    @

  $.fn.updateWith = (attribute, value) ->
    @each ->
      observer = $(@)
      switch attribute
        when "value"
          value = value.id() if typeof value is "object"
          observer.val value
        when "text"
          value = value.name() if typeof value is "object"
          observer.text value
        when "html"
          value = value.name() if typeof value is "object"
          observer.html value
        else
          observer.attr attribute, value
    @

  # Here we set up the event handlers that pass changes back to the object.
  #
  

  # ## Binding events to object methods
  #
  # You can associated any object method with any interface event with a declaration like this:
  #
  #   <a href="#" data-action="click: toggleVisibility" data-bind="text: name"></a>
  #
  # The toggleVisibility method will be called in the usual way, with the click event as its first
  # argument. You will presumably want to use the fat arrow to preserve context when the the method
  # is defined.
  #
  # This is all very simple and there is no unbind mechanism. It's only meant to be used for your 
  # basic menus and lists.
  #
  $.fn.bind_actions = (object) ->
    @each ->
      observer = $(@)
      if bindings = observer.attr('data-action')
        observer.attr('data-action', null)
        for binding in bindings.split(/,\s*/)
          [ev, fn] = binding.split(/:\s+/)
          object.bindAction @, fn, ev




    
