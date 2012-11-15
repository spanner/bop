jQuery ($) ->

  class Space extends Bop.Module
    constructor: (element, @_page) ->
      @_container = $(element)
      @_name = @_container.attr('data-bop-space')
      @sortable()
      @_container.find('[data-bop-item]').bop_placement(@)
      @_adder = $("<a href='#' class='adder'>Add something</a>").appendTo(@_container)
      @_adder.click @addItem
    
    element: () =>
      @_container
      
    name: () =>
      @_name
      
    page: () =>
      @_page
      
    addItem: (e) =>
      e.preventDefault() if e
      block_element = $('<article class="block" />').insertBefore(@_adder).html("<p>Double-click to edit!</p>").bop_block(@)

    unsortable: () =>
      @_container.sortable( "option", "disabled", true )

    sortable: () =>
      if @_sorting
        @_container.sortable( "option", "disabled", false )
      else
        @_container.sortable
          items: 'article'
          axis: "y"
          connectWith: 'section.space'
          start: (event, ui) =>
            ui.placeholder.height(ui.item.height())
          update: (event, ui) =>
            array = @_container.sortable "toArray"
            $.each array, (i, id) =>
              data =
                placed_block: 
                  position: i+1
              if ui.item.attr("id") == id
                data["placed_block"]["space_name"] = @_container.attr('data-bop-space')
              id = id.split("placed_block_")[1]
              $.ajax
                url: "/bop/pages/#{@_page.id()}/placed_blocks/#{id}"
                type: "PUT"
                dataType: "JSON"
                data: data
        @_sorting = true
      



  $.fn.bop_space = (page) ->
    @each ->
      new Bop.Space(@, page)
  
    
  $.namespace "Bop", (target, top) ->
    target.Space = Space
