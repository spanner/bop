jQuery ($) ->
  class Block extends Bop.Module
    constructor: (element, @_space, @_type) ->
      @_container = $(element)
      @_container.addClass('editable')
      @_page = @_space.page()
      @_id = @_container.attr('data-bop-block')
      @_type ?= @_container.attr('data-bop-blocktype')
      @create() unless @_id?
      @ready()
    
    id: () => 
      @_id
    
    ready: (e) =>
      @_container.bind "dblclick", @edit
      @_space.unsortable()
      
    default_content: () =>
      switch @_type
        when "text" then $("<p>Double-click to edit!</p>")
        when "image" then $('<div class="uploader" />')
      
    create: () =>
      $.ajax
        url: "/bop/pages/#{@_page.id()}/blocks"
        type: "POST"
        dataType: "JSON"
        data: 
          space: @_space.name()
          block: 
            content: @_container.html()
        error: @error
        success: @created

    created: (response) =>
      @_id = response.id
      @_container.attr('data-bop-block', @_id)
      @_container.flash("#8dd169")
    
    edit: (e) =>
      e.preventDefault()
      @_container.unbind "dblclick", @edit
      @_space.sortable( "option", "disabled", true )
      @_editor = new BlockEditor @_container, @
      
    update: (content) =>
      $.ajax
        url: "/bop/pages/#{@_page.id()}/blocks/#{@id()}"
        type: "PUT"
        data: 
          block: 
            content: content
        dataType: "JSON"
        success: @updated
        error: @error
      
    updated: (response) =>
      @_container.flash("#8dd169")
      @ready()

    error: (a, b, c) =>
      @_container.flash("#ff0000")
      console.log "Block save error", a, b, c
      @ready()
      
    destroy: () =>
      @_container.slideUp () =>
        #todo: destroy on server
        @_container.remove()
        @_content.destroy()
        delete @

  
  $.fn.bop_block = (space) ->
    @each ->
      new Bop.Block(@, space)
    @




  class BlockEditor extends Bop.Module
    constructor: (element, @_block) ->
      @_editable = $(element)
      @_id = @_editable.attr('data-bop-block')
      @_blocktype = @_editable.attr('data-bop-blocktype')
      @_editable.wrap('<div class="editing" />')
      @_container = @_editable.parents('.editing')
      @_initial_content = @_editable.html()
      @setBlockType(@_blocktype)
      @show()

    setBlockType: (blocktype) =>
      console.log ">>> set block type to #{blocktype}"
      @_blocktype = blocktype
      # show the appropriate interface: content editor, uploader, picker
      switch blocktype
        when "text"
          # make editable and hook up callbacks
        when "image"
          # set up uploader
          # any existing asset will be in the frame





    revert: (e) =>
      e.preventDefault() if e
      @_controls.remove()
      @_chooser.destroy()
      @_editable.unwrap()
      @_editable.html(@_initial_content)
      @_block.ready()
      # stand down the various editors that might be in play

    submit: () =>
      # where are we getting our content from?
      @_controls.remove()
      @_chooser.destroy()
      @_editable.unwrap()
      @_block.update()

    show: () =>
      unless @_controls?
        @_controls = $("<div class='controls'><button class='submit ui-button ui-corner-all'>save</button><button class='cancel ui-button ui-corner-all'>cancel</a></div>")
        @_controls.find('.submit').bind "click", @submit
        @_controls.find('.cancel').bind "click", @revert
        @_editable.after @_controls
        @_chooser = new BlockTypeChooser
          callback: @setBlockType
        @_editable.after @_chooser.element
      @_controls.show()

    hide: () =>
      @_controls?.hide()



  class BlockTypeChooser extends Bop.Module
    constructor: (opts) ->
      @_options = $.extend
        blocktypes: [
          'text'
          'image'
          'video'
          'audio'
        ]
        icons:
          text: "asterisk"
          image: "picture"
          video: "play-circle"
          audio:"music"
        callback: null
        buttonClasses: "chooser ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only"
      , opts
      classes = [
      ]
      @_container = $('<div class="blocktyper"></div>')
      @_button = $("<button class=\"#{@_options.buttonClasses}\"></button>").appendTo(@_container)
      @_indicator = $("<span class=\"text icon-asterisk\"> text</span>").appendTo(@_button)
      @_dropdown = $("<div class=\"dropdown\"></div>").appendTo(@_container).hide()
      @_type_list = $("<ul class=\"blocktypes\"></ul>").appendTo(@_dropdown)
      for blocktype in @_options.blocktypes
        @_type_list.append @blockTypeOption(blocktype)
      @_button.click @toggle
      
    element: () =>
      @_container

    #todo: these should come from a proper model class, each with its own icon, name and default content
    blockTypeOption: (blocktype) => 
      el = $("<li class='blocktype'><a href=\"#\" class=\"menu-item\"><span class=\"icon-#{@_options.icons[blocktype]}\"></span> #{blocktype}</span></li>")
      el.bind 'click', (e) =>
        e.preventDefault() if e
        @_dropdown.find('li').removeClass('selected')
        el.addClass('selected')
        @showBlockType(blocktype)
        @hide()
        @_options.callback?(blocktype)
      el

    showBlockType: (blocktype) =>
      console.log "showBlockType", blocktype
      console.log "icons", @_options.icons
      for bt in @_options.blocktypes
        @_indicator.removeClass("icon-#{@_options.icons[bt]}")
      @_indicator.addClass("icon-#{@_options.icons[blocktype]}")
      @_indicator.text(" #{blocktype}")
    
    place: () =>
      {top, left} = @_button.position()
      @_dropdown.css 'top', top + @_button.outerHeight() - 4
      @_dropdown.css 'left', left
      @_dropdown.css 'width', @_button.outerWidth() - 2
    
    toggle: () =>
      console.log "toggle", @_dropdown.is ":visible"
      if @_dropdown.is ":visible" then @hide() else @show()
      
    show: () =>
      @place()
      @_dropdown.fadeIn('fast')
      
    hide: () =>
      @_dropdown.fadeOut('fast')

    destroy: () =>
      @_container.remove()
      delete @


  $.namespace "Bop", (target, top) ->
    target.Block = Block
