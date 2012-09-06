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
      @_tabs.forEach (t)->
        t.hide()
        
    constructor: (element) ->
      @_tab = $(element)
      @_url = $(element).attr('data-tab')
      @get_body()      
      Tab._tabs.push(@)
      @_tab.bind "click", @show
      
    get_body: () =>
      $.ajax
        url: @_url
        dataType: 'html'
        success: (data) =>
          @_body = $(data).appendTo('.pagetree')
          @hide()
          @_adder = $(@_body).find("[data-link='remote']")
          $(@_adder).on "ajax:success", @add
    
    add: (a, b, c) =>
      $(@_adder).hide()
      @_new = $(b).insertAfter($(@_body).find('li').last())
      $(@_new).find('form').on "ajax:success", (a, b, c) =>
        $(b).insertBefore(@_new)
        $(@_new).remove()
        @_new = null
        $(@_adder).show()        
        
    
    show: () =>
      Tab.hideAll()
      $(@_body).show()
      
    hide: () =>
      $(@_body).hide()
 
  $.namespace "Bop", (target, top) ->
    target.Menu = Menu
