jQuery ($) ->

  class TemplateSet extends Bop.Module
    constructor: (element) ->
      @_container = $(element)
      @_container.find('.template').bop_template()
      @_container.find('a.adder').remote_link(@addTemplate)
      
    addTemplate: (response) =>
      new_template = $(response)
      $(response).appendTo(@_container.find('ul')).bop_template()

  class Template extends Bop.Editable
      

  $.fn.bop_template_set = ->
    @each ->
      new Bop.TemplateSet(@)

  $.fn.bop_template = ->
    @each ->
      new Bop.Template(@)


  $.namespace "Bop", (target, top) ->
    target.TemplateSet = TemplateSet
    target.Template = Template
