# The uploader is an html5 file uploader, scaler and cropper that sits in front of our Asset class. 
# It is normally used to upload one asset into a scaling block, which happens in these stages:
#
# 1. Show an Uploader (which is a dropbox inside a standard rails form)
# 2. Select a file either by picking or dropping
# 3. Send the FormData, including selected file, over xmlhttp
# 4. Receive back another form, containing the uploaded image, suitable 
#    for instantiating a Cropper object.
# 5. Use the crop and scale controls to manipulate the display of the image
#    and the corresponding values in the cropping form.
# 6. Submit the cropping form (which is just data) over xmlhttp
# 7. Display the response, which will be the scaled, cropped image tag.
#
# This only works in modern browsers with support for XMLHttpRequest 2 (ie that have FormData).
# Explorer 9 does not. Explorer 10 is supposed to. Firefox, Chrome and Safari should all be fine.


# *** We're also going to need an existing-asset-picker in here ***

jQuery ($) ->
  
  # The Uploader class is just an event-handling wrapper around a standard rails new-asset form.
  # It attaches a change binding to the file field and sets up drop and pick bindings that will 
  # cause it to change. The effect is to trigger an immediate form submission over xhr.
  #
  # The constructor takes two arguments: a form and a callback function. The form is expected  
  # to contain a dropbox div: it should be contained within an asset form. The callback
  # is fired on successful upload and receives the response and the uploader as its arguments.
  #
  # Any links within the form having the '.picker' class will trigger a click on the file field.
  # The dropbox can be omitted if there is a picker present, or if the file field is visible.
  #
  class Uploader extends Bop.Module
    constructor: (form, opts) ->
      @_form = $(form)
      @_options = $.extend {}, opts
      @_dropbox = @_form.find('.dropbox')
      @_filefield = @_form.find('input[type="file"]')
      @_instructions = @_form.find("p.upload_instructions")
      @_form.find("a.picker").click_proxy(@_filefield)
      @_dropbox
        .bind("dragenter", @dragEnter)
        .bind("dragleave", @dragLeave)
        .bind("drop", @drop)
      @_filefield.bind("change", @pick)
      @_file = null
    
    dragEnter: () =>
      @_dropbox.addClass("hover")

    dragLeave: () =>
      @_dropbox.removeClass("hover")
    
    # *Drop* is fired when a document is dropped on a .dropbox element within the form.
    # It passes the dragged file(s) to begin()
    #
    drop: (e) =>
      e.preventDefault() if e
      @dragLeave()
      @begin(e.dataTransfer.files)
      @trigger('drop')
        
    # *Pick* is fired when one or more documents are assigned to the file field through 
    # the usual dialog. It passes the selected file(s) to begin()
    #
    pick: (e) =>
      e.preventDefault() if e
      @begin(@_filefield[0].files)
      @trigger('pick')
    
    # *Begin* sets up the display of upload progress, mostly by attaching a ProgressBar object
    # to the dropbox.
    #
    begin: (files) =>
      if file = files.item(0)
        @cancel() if @_file
        @_file = file
        @_instructions.hide()
        @_progress = new ProgressBar(@_dropbox)
        @_canceller = $('<a class="cancel" href="#">cancel</a>').appendTo(@_dropbox)
        @send()
        @trigger('begin')

    # Then *send* sets up the XHR transfer and its callbacks. Using FormData rather than 
    # serializing the form means that to Rails this looks just like a normal form submission. 
    # We don't have to worry about rails conventions like the CSRF token or _method parameter 
    # because they're already on the form.
    # 
    send: () =>
      formData = new FormData @_form.get(0)
      @_xhr = new XMLHttpRequest()
      @_xhr.upload.onprogress = @progress
      @_xhr.upload.onloadend = @uploaded
      @_xhr.upload.onreadystatechange = @finish
      @_xhr.timeout = @_xhr.error = @fail
      @_canceller.click @cancel
      @_xhr.open('POST', @_form.attr('action'), true)
      @_xhr.send(formData)
    
    # The *Progress* callback receives a percentage value and passes it on to the Progressbar
    # to update the display.
    #
    progress: (value) =>
      @_progress.set(value)
      @trigger('progress', value)
    
    # The *uploaded* callback is fired on loadend, when the upload has finished. There is usually
    # another wait while the uploaded asset is processed by Paperclip, so we update the progress
    # bar accordingly.
    #
    uploaded: () =>
      @_progress.say("Processing file")
      @trigger('uploaded')

    # The *finish* callback is fired when we finally get a response. It removes the present form,
    # replaces it with the response and then passes that new html to whatever callback was 
    # originally specified. In the case of page editing, what we get back is a new form that we
    # can pass to the Cropper for further modification.
    #
    # Without a callback, the effect is just to replace the original form with the returned html.
    #
    # At the moment we are not handling the case where the original upload comes back with validation
    # problems.
    #
    # The callback setup makes it difficult to cancel this process once the initial upload has
    # handed over to the cropper, but it's necessary because there are cases where we don't want to 
    # crop the upload: either it's a non-image asset, or we're batch-uploading into the asset list.
    #
    finish: (response) =>
      if @xhr.readyState == 4
        if @xhr.status == 200
          @_file = null
          @_form.after(response)
          @_form.hide()
          @_canceller.remove()
          @_progress.remove()
          @_xhr = null
          if @_options.cropped?
            @_cropper = new Cropper(response, @)
            @_cropper.bind('cancel', @revert)
            @_cropper.bind('complete', @remove)
            
          @trigger('success', response)
        else
          @fail(response)
    
    # *Fail* is hit whenever an XHR request goes bad.
    #
    fail: (args...) =>
      console.log("fubar!", args)
      @trigger('error', args)
    
    # *Cancel* is triggered if the upload is aborted, either by pressing our cancel button
    # or by some other browser action.
    #
    cancel: () =>
      @_xhr?.abort()
      @revert()
    
    # *Revert* returns the whole uploader to its original condition, ready to start again. It can
    # be called from any stage in the extended process of uploading and cropping.
    #
    revert: () =>
      @_file = null
      @_filefield.val("")
      @_progress.remove()
      @_canceller.remove()
      @_instructions.show()
      @_form.show()
      @trigger('revert', args)
    
    # *Remove* gets rid of this uploader and its form. Up to you what happens after that.
    #
    remove: () =>
      @_form.remove()
      delete @
      @trigger('remove', args)



  # `$('form').uploader` sets up an uploader that replaces itself with the response. Pass `cropped: true`
  # to hand over to a Cropper after uploading.
  # 
  $.fn.uploader = (opts) ->
    if Modernizr.filereader
      @each ->
        up = new Uploader(@, opts)
    else
      @html("Uploads are not supported by your browser")
    @

  # `$('a').recropper` returns us to the cropper stage by asking rails for that form (which we assume 
  # is returned by the link). This is just a placeholder: there will be a better way to find or create 
  # the dropbox element.
  # 
  $.fn.recropper = ->
    @each ->
      link = $(@)
      link.remote_link (response) =>
        link.hide()
        link.after(response)
        crop = new Cropper(response)
        crop.bind "cancel", () ->
          link.show()
        
    @


  # The Cropper presents an image in a draggable, scalable form and records the dragging and scaling
  # in the containing form. The width, height, left and top values we record are used by a custom 
  # Papeclip processor to scale the image to that size and crop only that part of the image. The result
  # should be to return a exactly the image that was described in the cropper.
  #
  class Cropper extends Bop.Module
    constructor: (response) ->
      @_form = $(response)
      # The preview is a container for the scalable image. Its overflow should be hidden so that
      # only the cropped portion of the image can be seen. Often the container is itself resizable.
      #
      @_preview = @_form.find("div.preview")
      # The crop fieldset should contain all our attribute fields.
      #
      @_fields = @_form.find("fieldset.crop")
      # The overflow is a semi-opaque replica of the scaling image, placed behind and outside its
      # container so as to show the cropped-out part of the picture.
      #
      @_overflow = $('<div class="overflow">').append(@_preview.find("img").clone())
      @_preview.before @overflow
      # Initial settings are taken from the supplied html, since we might be editing an existing crop.
      # In that case the initial form field values will also be set, so we might decide to use those.
      #
      @_top = @preview.position().top
      @_left = @preview.position().left
      @_lastX = 0
      @_lastY = 0

      # Range support is still very patchy so we have to superimpose a scaler widget.
      #
      @_scaler = new Scaler(@_fields.find('input[type="range"]'))
      @_scaler
        .bind("dragStart", @showOverflow)
        .bind("dragMove", @resize)
        .bind("dragEnd", @hideOverflow)
      
      # The form here is just numerical data, so there is no need for anything fancy.
      #
      @_form.remote_form @complete
      @_form.find("a.cancel").bind "click", @cancel
      @_preview.bind("mousedown", @dragStart)

      @recalculateLimits()
      @setOverflow()
    
    # *dragStart* is called on mousedown. It sets up temporary move and drop handlers in the usual way,
    # records the origin of the movement, if there is one and brings up the overflow for context.
    # The event is allowed through.
    #
    dragStart: (e) =>
      e.preventDefault()
      $(document).bind "mousemove", @dragMove
      $(document).bind "mouseup", @dragEnd
      @lastY = e.pageY
      @lastX = e.pageX
      @showOverflow()
      @trigger('dragStart', e)
    
    # *dragMove* is triggered when the preview is dragged to a new position. It updates the associated form fields
    # by calling moveTop and moveLeft (so as to integrate with the action of the scaler), then sets the 
    # position of the overflow.
    #
    dragMove: (e) =>
      e.preventDefault()
      @moveTop e.pageY - @lastY
      @moveLeft e.pageX - @lastX
      @lastY = e.pageY
      @lastX = e.pageX
      @setOverflow()
      @trigger('dragMove', e)

    # *dragEnd* is called when the preview is dropped. It makes sure that the final move has been called, lets the
    # drag events go and hides the overflow.
    #
    dragEnd: (e) =>
      $(document).unbind "mousemove", @move
      $(document).unbind "mouseup", @drop
      @dragMove(e)
      @hideOverflow()
      @trigger('dragEnd', e)

    # *resize* is called back by the scaler. With a fixed aspect ratio we only need to work with width, which 
    # is stored in the range input. scaled_height is calculated and stored in a hidden field, then we reset
    # the drag furniture. This is another move handler so it can be called very frequently.
    #
    resize: (w) =>
      h = Math.round(w * @aspect)
      deltaT = Math.round((w - @preview.width()) / 2)
      deltaL = Math.round((h - @preview.height()) / 2)
      @preview.css
        width: w
        height: h
      @fields.find("input.sh").val h
      @recalculateLimits()
      @moveTop(-deltaT)
      @moveLeft(-deltaL)
      @setOverflow()
      @trigger('resize', w, h)

    # The preview image should always fill its container: it can't be dragged or resized away from any of the edges.
    # *recalculateLimits* is called whenever the size of the image changes (or is first set) to reset the bounds for 
    # dragging and scaling.
    #
    recalculateLimits: (argument) =>
      @toplimit = @container.height() - @preview.height()
      @leftlimit = @container.width() - @preview.width()
      @aspect = @preview.height() / @preview.width()

    # *moveTop* handles the y-axis and *moveLeft* the x-axis, updating form fields and moving the preview as required.
    #
    moveTop: (y) =>
      @top = @top + y
      @top = 0 if @top > 0
      @top = @toplimit if @top < @toplimit
      @preview.css "top", @top
      @fields.find("input.ot").val @top
      @trigger('moveTop', y)

    moveLeft: (x) =>
      @left = @left + x
      @left = 0  if @left > 0
      @left = @leftlimit  if @left < @leftlimit
      @preview.css "left", @left
      @fields.find("input.ol").val @left
      @trigger('moveLeft', x)
    
    # *showOverflow* fades in the overflow div (which will track the position and scale of the preview).
    #
    showOverflow: =>
      @overflow.fadeTo('normal', 0.3)
      @trigger('showOverflow')

    # and *hideOverflow* hides it again.
    #
    hideOverflow: =>
      @overflow.fadeOut('normal')
      @trigger('hideOverflow')

    # *setOverflow* updates the size and position of the overflow to match that of the preview. The overflow
    # is an uncropped clone of the preview that sits behind it: the effect is to show in a pale form how much
    # of the image remains.
    #
    setOverflow: (argument) =>
      @overflow.css
        width: @preview.width()
        height: @preview.height()
      @overflow.offset @preview.offset()

    # Calling *cancel* will take us all the way back to the beginning of this process.
    #
    cancel: (e) =>
      e.preventDefault()
      @_form.remove()
      @trigger('cancel')


    # Form posting is handled by our usual RemoteForm. On success it calls back to here,
    # and we replace the form with whatever was returned. Usually that's a finished, cropped image
    # with a recrop link around it that will bring up the cropping interface again with the previously
    # chosen values in place.
    #
    complete: (response) =>
      e.preventDefault()
      replacement = $(response)
      @_form.after(replacement)
      @_form.remove()
      $(replacement).find('a.recrop').recropper()
      @trigger('complete')





  # The Scaler is a general-purpose range-input replacement widget. Most browsers still render a range
  # input just as a text field with a number in it, perhaps with some rubbishy arrow business. This
  # just puts a slider in its place, updating the field as its position changes and incidentally
  # firing various event callbacks.
  #
  # There are only two kinds of work here: to handle the interface events and to translate between pixel 
  # values and the corresponding position within the range of values allowed by the input.
  #
  # We rely on triggers to update the rest of the interface when the scaler value changes.
  #
  class Scaler extends Bop.Module
    constructor: (range) ->
      @_input = $(range)
      @_pos = 0
      @value = @_input.val()
      @max = parseInt(@_input.attr("max"), 10)
      @min = parseInt(@_input.attr("min"), 10)
      @_container = $('<span class="slider"></span>')
      @_scale = $('<span class="scale"></span>').appendTo(@_container)
      @_handle = $('<span class="marker"></span>').appendTo(@_scale)
      @_input.before(@_container).hide()
      # The size of the scaler has to be set in CSS. All calculations are relative to that value.
      @_scale_width = @_container.innerWidth()
      @_value_width = @max - @min
      @_lastX = 0

      @reposition()
      @_handle.bind("mousedown", @dragStart)

    # Method names here follow the conventions of the Cropper, and as there they usually trigger an event of
    # the same name. The Cropper binds several of those events to its display methods so that scaling has 
    # visible effect. Here all we have to do is update the range field.
    #
    # *dragStart* is called when there's a mousedown on the slider handle. It sets up temporary move and drop
    # handlers and records the origin of our movement.
    #
    dragStart: (e) =>
      e.preventDefault()
      @lastX = e.pageX
      $(document).bind "mousemove", @dragMove
      $(document).bind "mouseup", @dragEnd
      @trigger('dragStart', @value)

    # *dragMove* moves the handle, within its limits, and updates the range field accordingly.
    #
    dragMove: (e) =>
      deltaX = e.pageX - @_lastX
      @_pos = @pos + e.pageX - @_lastX
      @_pos = 0  if @pos < 0
      @_pos = 400  if @pos > 400
      @placeMarker()
      @setValue()
      @_lastX = e.pageX
      @trigger('dragMove', @value)

    dragEnd: (e) =>
      @dragMove(e)
      $(document).unbind "mousemove", @dragMove
      $(document).unbind "mouseup", @dragEnd
      @trigger('dragEnd', @value)

    # *setValue* uses the handle position (in pixels left) to set the range field value.
    #
    setValue: =>
      @value = Math.round(origin + (@_value_width * (@_pos / @_scale_width)))
      @_input.val(@value)
    
    # *setPosition* does the reverse: it uses the range field value to place the sliding handle.
    #
    setPosition: =>
      @_pos = Math.round(@scale_width * (@value - @min) / (@max - @min))
      @placeMarker()
    
    # *placeMarker* just puts the marker where it should be, based on our _pos. It is called whenever
    # pos is updated and should really be observing that value.
    placeMarker: () =>
      @_handle.css "left", @_pos - @_handle_offset
      @trigger('placeMarker',  @_pos)
      
    remove: =>
      @slider.remove()
      @trigger('remove')
    
    hide: =>
      @slider.hide()

    show: =>
      @slider.show()
      


  # The ProgressBar is a simple width-settable widget with a caption. It is appended to whatever
  # element is passed to the constructor and can then be used to show the progress of an upload.
  #
  class ProgressBar
    constructor: (element) =>
      @_container = $(element)
      @_holder = $("<div class=\"progress_holder\"></div>")
      @_bar = $("<div class=\"progress\"></div>").appendTo(@_holder)
      @_caption = $("<div class=\"commentary\">0% uploaded</div>").appendTo(@_holder)
      @_container.append(@_holder)
    
    # *set* adjusts the width of the progress bar within its holder and updates the caption to 
    # say 'width%'.
    #
    set: (value) =>
      @_bar.width(progress + "%")
      @say(progress + "% uploaded")
    
    # *Say* changes the caption without affecting the width of the progress bar.
    #
    say: (value) =>
      @_caption.text(value)
    
    # *Remove* gets rid of the DOM elements and this object.
    #
    remove: =>
      @_holder.remove()
      delete self
