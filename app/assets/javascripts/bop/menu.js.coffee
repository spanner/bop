jQuery ($) ->

  class Menu extends Bop.Module
    constructor: (element) ->
      @_container = $(element)
      @_tag = @_container.find('.boptag')
      @_tree = @_container.find('.pagetree')
      @_files = @_container.find('.files')
      @_showing = @_container.hasClass('showing')
      @_tag.click @toggle
      @_tabs = @_container.find('.admin')
      @_closed_state = 
        left: @_tag.width() - @_container.width()
        bottom: @_tag.height() - @_container.height()
      @_open_state = 
        left: 0
        bottom: 0
      @_tabs.find('a').each ->
        new Tab(@)
      
    toggle: (e) =>
      e.preventDefault()
      if @_showing then @hide() else @show()
  
    show: =>
      @_showing = true
      @_container.addClass('showing').animate @_open_state, 'slow', 'glide'

    hide: =>
      @_showing = false
      @_container.animate @_closed_state, 'fast', 'glide', () =>
        @_container.removeClass('showing')
        
  $.fn.bop_menu = ->
    @each ->
      new Bop.Menu(@)
  
 
  class Tab
    @_tabs = []
    @hideAll: () ->
      @_tabs.forEach (t) ->
        t.hide()
        
    constructor: (element) ->
      @_tab = $(element)
      if @_selector = @_tab.attr('data-tab')
        @_body = $(@_selector)
        @_tab.bind "click", @show
        Tab._tabs.push(@)
    
    show: () =>
      Tab.hideAll()
      console.log "show", @_selector
      @_body.show()
      @_tab.addClass('selected')
      
    hide: () =>
      console.log "hide", @_selector
      @_body.hide()
      @_tab.removeClass('selected')
 
  $.namespace "Bop", (target, top) ->
    target.Menu = Menu
