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
        $(@).addClass('waiting')
        xhr.setRequestHeader('X-PJAX', 'true')
      .on 'ajax:error', (event, xhr, status) ->
        $(@).removeClass('waiting').addClass('erratic')
        $.ajax_error(event, xhr, status)
      .on 'ajax:success', (event, response, status) ->
        callback?(response)
    @

  $.fn.remote_form = (callback) ->
    @
      .on 'ajax:beforeSend', (event, xhr, settings) ->
        console.log "beforeSend", @
        $(@).addClass('waiting')
        xhr.setRequestHeader('X-PJAX', 'true')
      .on 'ajax:error', (event, xhr, status) ->
        $(@).removeClass('waiting').addClass('erratic')
        $.ajax_error(event, xhr, status)
      .on 'ajax:success', (event, response, status) ->
        callback?(response)
    @


  $.ajax_error = (event, xhr, status) ->
    console.error "ajax error", event, xhr, status


  $.fn.html_editable = (toolbar)->
    @each ->
      textarea = $(@)
      toolbar.attr('id', $.makeGuid()) unless toolbar.attr('id')?
      textarea.attr('id', $.makeGuid()) unless textarea.attr('id')?
      editor = new wysihtml5.Editor textarea.attr('id'),
        stylesheets: ["/assets/application.css", "/assets/bop/wysihtml5.css"],
        toolbar: toolbar.attr('id'),
        parserRules: wysihtml5ParserRules
      toolbar.show()





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
    @find('textarea.editable').html_editable()
    @    

$ -> 
  $('body').activate()

