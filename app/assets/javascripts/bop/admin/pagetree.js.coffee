jQuery ($) ->

  class PageTree extends Bop.Module
    constructor: (element) ->
      @_container = $(element)
      @_container.find('.page').bop_page_tree_page()

  class PageTreePage extends Bop.Editable
    show: () =>
      super
      @_container.children('a.adder').remote_link(@addChild)
    
    addChild: (response) =>
      new_page = $(response)
      $(response).appendTo(@_container).bop_page_tree_page()

  $.fn.bop_page_tree = ->
    @each ->
      new Bop.PageTree(@)

  $.fn.bop_page_tree_page = ->
    @each ->
      new Bop.PageTreePage(@)

 
  $.namespace "Bop", (target, top) ->
    target.PageTree = PageTree
    target.PageTreePage = PageTreePage
