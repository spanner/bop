jQuery ($) ->

  class Menu extends Bop.Module
    constructor: (element) ->
      @_container = $(element)
      @_tag = @_container.find('.boptag')
      @_tree = @_container.find('.pagetree')
      @_files = @_container.find('.files')
      @_showing = @_container.hasClass('showing')
      @_tag.click @toggle
      @_admin = @_container.find('.admin')
      @_closed_state = 
        left: @_tag.width() - @_container.width()
        bottom: @_tag.height() - @_container.height()
      @_open_state = 
        left: 0
        bottom: 0
      @_admin.find('a.design').on 'ajax:success', @show_files
      
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
        
    show_files: (a, b, c) =>
      $(@_files).children().remove()
      $(b).appendTo(@_files)

  $.fn.bop_menu = ->
    @each ->
      new Bop.Menu(@)
  
 
  $.namespace "Bop", (target, top) ->
    target.Menu = Menu
