#     Hallo - a rich text editing jQuery UI widget
#     (c) 2011 Henri Bergius, IKS Consortium
#     Hallo may be freely distributed under the MIT license
((jQuery) ->
  jQuery.widget 'IKS.halloblocktype',
    options:
      editable: null
      toolbar: null
      uuid: ''
      blocktypes: [
        'html'
        'image'
        'video'
        'audio'
      ]
      buttonCssClass: "blocktypebutton"

    populateToolbar: (toolbar) ->
      buttonset = jQuery "<span class=\"#{@widgetName}\"></span>"
      contentId = "#{@options.uuid}-#{@widgetName}-data"
      target = @_prepareDropdown contentId
      toolbar.append buttonset
      buttonset.hallobuttonset()
      buttonset.append target
      buttonset.append @_prepareButton target

    _prepareDropdown: (contentId) ->
      content_area = jQuery("<div id=\"#{contentId}\" class=\"dropdown-menu\"></div>")
      block_type_list = jQuery("<ul class=\"blocktypelist\"></ul>").appendTo(content_area)
      icons = 
        html: "asterisk"
        image: "picture"
        video: "play-circle"
        audio:"music"
      
      addType = (blocktype) =>
        el = jQuery "<li class='blocktype'>
          <a href=\"#\" class=\"menu-item\"><span class=\"icon-#{icons[blocktype]}\"></span> #{blocktype}</span>
        </li>"
      
        # if current block type is blocktype
        #   el.addClass 'selected'
        # 
        # unless containingElement is 'div'
        #   el.addClass 'disabled'

        el.bind 'click', =>
          # tagName = blocktype.toUpperCase()
          # if el.hasClass 'disabled'
          #   return
          # if jQuery.browser.msie
          #   # In IE FormatBlock wants tags inside brackets
          #   @options.editable.execute 'FormatBlock', "<#{tagName}>"
          #   return
          # @options.editable.execute 'formatBlock', tagName
          
        queryState = (event) =>
          block = document.queryCommandValue 'formatBlock'
          if block.toLowerCase() is blocktype
            el.addClass 'selected'
            return
          el.removeClass 'selected'
        
        events = 'keyup paste change mouseup'
        @options.editable.element.bind events, queryState

        @options.editable.element.bind 'halloenabled', =>
          @options.editable.element.bind events, queryState
        @options.editable.element.bind 'hallodisabled', =>
          @options.editable.element.unbind events, queryState

        el

      for blocktype in @options.blocktypes
        block_type_list.append addType blocktype
      content_area

    _prepareButton: (target) ->
      buttonElement = jQuery '<span></span>'
      buttonElement.hallodropdownbutton
        uuid: @options.uuid
        editable: @options.editable
        label: ' html'
        target: target
        icon: 'icon-caret-right'
        cssClass: @options.buttonCssClass
      buttonElement

)(jQuery)
