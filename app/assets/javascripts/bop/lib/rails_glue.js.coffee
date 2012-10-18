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

  $.fn.editable = ->
    @each ->
      container = $(@).parents('.editing').first()
      $(@).hallo
        editable: true
        toolbar: 'halloToolbarFixed'
        parentElement: container
        plugins:
          halloreundo: true
          hallolists: true
          hallolink: true
          halloformat: 
            formattings:
              bold: true
              italic: true
          halloheadings: 
            headers: [1,2,3]

  $.fn.ineditable = ->
    @hallo
      editable: false
