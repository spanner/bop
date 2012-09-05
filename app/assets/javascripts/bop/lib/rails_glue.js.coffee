jQuery ($) ->


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


  $.fn.html_editable = ->
    @each ->
      editor = new wysihtml5.Editor "textarea_#{@_id}",
        stylesheets: ["/assets/application.css", "/assets/bop/wysihtml5.css"],
        toolbar: "toolbar_#{@_id}",
        parserRules: wysihtml5ParserRules
      @editor.on "change", () =>
        


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

