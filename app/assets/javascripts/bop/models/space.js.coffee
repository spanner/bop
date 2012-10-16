jQuery ($) ->

  class Space extends Bop.Module
    constructor: (element, @_page) ->
      @_container = $(element)
      @_name = @_container.attr('data-bop-space')
      @_container.find('[data-bop-block]').bop_block(@)
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
          
            
      @_adder = $("<a href='#' class='adder'>Add block</a>").appendTo(@_container)
      @_adder.click @addBlock
        
    name: () =>
      @_name
      
    page: () =>
      @_page
      
    addBlock: (e) =>
      e.preventDefault() if e
      block_element = $('<article class="block" />').insertBefore(@_adder).html("<p>Double-click to edit!</p>").bop_block(@)


  $.fn.bop_space = (page) ->
    @each ->
      new Bop.Space(@, page)
  
    
  $.namespace "Bop", (target, top) ->
    target.Space = Space
