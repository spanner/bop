jQuery ($) ->
  
  $.fn.validation_error = ->
    @each ->
      container = $(this)
      container.fadeIn "fast"
      $("<a href=\"#\" class=\"closer\">close</a>").prependTo(container).bind "click", (e) ->
        e.preventDefault()
        container.fadeOut "fast"
        container.parent().removeClass "erratic"

  $.fn.replace_with_remote_content = () ->
    @
      .on 'ajax:beforeSend', (event, xhr, settings) ->
        $(@).addClass('waiting')
        xhr.setRequestHeader('X-PJAX', 'true')
      .on 'ajax:error', (event, xhr, status) ->
        $(@).removeClass('waiting').addClass('erratic')
      .on 'ajax:success', (event, response, status) ->
        if response? && response != " "
          self = $(@)
          container = $(@).parents('.holder').first()
          replacement = $(response)
          self.removeClass('waiting')
          replacement.insertAfter(container).activate().hide()
          if replacement.find('form').length
            replacement.addClass('editing')
          else
            replacement.removeClass('editing')
          container.slideUp 'fast', () ->
            replacement.slideDown 'fast'
          replacement.find('a.cancel').click (e) ->
            e.preventDefault()
            replacement.slideUp 'fast', () ->
              replacement.remove()
              container.slideDown('fast')

  $.fn.toggle = ->
    @each ->
      selector = $(@).attr('data-toggled')
      $(selector).hide() unless @checked
      $(@).click (e) ->
        if @checked then $(selector).slideDown() else $(selector).slideUp()
        
  $.fn.removes = (selector) ->
    @
      .on 'ajax:beforeSend', (event, xhr, settings) ->
        $(@).addClass('waiting')
        xhr.setRequestHeader('X-PJAX', 'true')
      .on 'ajax:error', (event, xhr, status) ->
        $(@).removeClass('waiting').addClass('erratic')
      .on 'ajax:success', (event, response, status) ->
        $(@).parents(selector).first().slideUp 'fast', () ->
          $(@).remove()

  $.fn.submitter = ->
    @click (e) ->
      $(@).addClass('waiting').text('Please wait')

  $.fn.click_proxy = (target_selector) ->
    this.bind "click", (e) ->
      e.preventDefault()
      $(target_selector).click()

  $.fn.activate = ->
    @find('.error_message').validation_error()
    @find('.toggle').toggle()
    @find('a.delete').removes('.holder')
    @find('a.fetch').replace_with_remote_content()
    @find('input[type="submit"]').submitter()
    @    

$ -> 
  $('body').activate()

