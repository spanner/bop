jQuery ($) ->

  # minimal rfc4122 generator taken from http://stackoverflow.com/questions/105034/how-to-create-a-guid-uuid-in-javascript
  $.makeGuid = ()->
    'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace /[xy]/g, (c) ->
      r = Math.random()*16|0
      v = if c is 'x' then r else r & 0x3 | 0x8
      v.toString 16

  $.fn.remote_link = (callback) ->
    @
      .on 'ajax:beforeSend', (event, xhr, settings) ->
        console.log "remote_link ajax:beforeSend"
        $(@).addClass('waiting')
        xhr.setRequestHeader('X-PJAX', 'true')
      .on 'ajax:error', (event, xhr, status) ->
        $(@).removeClass('waiting').addClass('erratic')
        $.ajax_error(event, xhr, status)
      .on 'ajax:success', (event, response, status, xhr) ->
        console.log "success"
        $(@).removeClass('waiting')
        callback?(response)
    @

  $.fn.remote_form = (callback) ->
    @
      .on 'ajax:beforeSend', (event, xhr, settings) ->
        console.log "remote_form ajax:beforeSend"
        $(@).addClass('waiting')
        xhr.setRequestHeader('X-PJAX', 'true')
      .on 'ajax:error', (event, xhr, status) ->
        $(@).removeClass('waiting').addClass('erratic')
        $.ajax_error(event, xhr, status)
      .on 'ajax:success', (event, response, status) ->
        $(@).removeClass('waiting')
        callback?(response)
    @

  $.ajax_error = (event, xhr, status) ->
    console.error "ajax error", event, xhr, status


  class Editor
    constructor: (element) ->
      @_container = $(element)
      @_original_textarea = @_container.find('textarea')
      @_toolbar = @_container.find('.toolbar')
      @_toolbar.attr('id', $.makeGuid()) unless @_toolbar.attr('id')?
      @_original_textarea.attr('id', $.makeGuid()) unless @_original_textarea.attr('id')?
      console.log @_original_textarea.attr('id')
      @_stylesheets = ["/assets/bop.css"]
      $.each $("head link[data-wysihtml5='custom_css']"), (i, link) =>
        @_stylesheets.push $(link).attr('href')
      @_editor = new wysihtml5.Editor @_original_textarea.attr('id'),
        stylesheets: @_stylesheets,
        toolbar: @_toolbar.attr('id'),
        parserRules: wysihtml5ParserRules,
        useLineBreaks: false
      @_toolbar.show()
      @hideToolbar()
      @resizeArea()
      @_original_textarea.bind "keyup", @resizeArea
      @_editor.on "load", () =>
        @_iframe = @_editor.composer.iframe
        $(@_editor.composer.doc).find('html').css
          "height": 0
          "overflow": "hidden"
        @_iframe_body = $(@_editor.composer.doc).find('body')
        @_iframe_body.css
          "font-size": "1em"
        @_textarea = @_original_textarea
        @resizeIframe()
        @_textarea = @_editor.composer.element
        @_textarea.addEventListener("keyup", @resizeIframe, false)
        @_textarea.addEventListener("blur", @resizeIframe, false)
        @_textarea.addEventListener("focus", @resizeIframe, false)
    
        @_container.bind("mouseenter", @showToolbar)
        @_container.bind("mouseleave", @hideToolbar)
        
    resizeIframe: () =>
      @_iframe_body.css
        "font-size": "1em"
      if $(@_iframe).height() != @_textarea.offsetHeight
        $(@_iframe).height @_textarea.offsetHeight
    
    resizeArea: () =>
      if @_original_textarea.height() != @_original_textarea[0].scrollHeight
        @_original_textarea.height 20
        @_original_textarea.height @_original_textarea[0].scrollHeight
          
    showToolbar: () =>
      @_hovered = true
      @_toolbar.fadeTo(200, 1)
    
    hideToolbar: () =>
      @_hovered = false
      @_toolbar.fadeTo(1000, 0.2)

  $.fn.html_editable = ()->
    @each ->
      editor = new Editor @

  $.fn.submitter = ->
    @click (e) ->
      $(@).addClass('waiting').text('Please wait')

  $.fn.validation_error = ->
    @each ->
      container = $(this)
      container.fadeIn "fast"
      $("<a href=\"#\" class=\"closer\">close</a>").prependTo(container).bind "click", (e) ->
        e.preventDefault()
        container.fadeOut "fast"
        container.parent().removeClass "erratic"

  $.fn.activate = ->
    @find('.error_message').validation_error()
    @find('input[type="submit"]').submitter()
    @    

$ -> 
  $('body').activate()

