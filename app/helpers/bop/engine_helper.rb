module Bop
  module EngineHelper

    # Views that require extra javascripts or stylesheets should declare them in a :bop_js or :bop_css block.
    # NB. Code editor views have their own layout and don't use this mechanism at all.
    #
    def bop_head
      output = content_for(:head)
      if user_signed_in?
        output << stylesheet_link_tag("bop")
        output << content_for(:bop_css)
      end
      output.html_safe
    end

    #todo: sanitize?
    #
    def bop_body
      space(:body)
    end

    def bop_foot
      output = content_for(:footer)
      if user_signed_in?
        output << render(:partial => 'bop/tools')
        output << javascript_include_tag("bop")
        output << content_for(:bop_js)
      end
      output.html_safe
    end




    # Places on a page the html contents of every block in the named space
    #
    def space(space_name)
      render :partial => "bop/placements/space", :object => space_name.to_s
    end
    
    def field(field_name)
      content_tag "span", @page.send(field_name.to_s.strip.to_sym), :class => "editable", :'data-bop-field' => field_name
    end

  end
end

