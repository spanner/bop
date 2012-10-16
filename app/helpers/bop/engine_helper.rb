module Bop
  module EngineHelper

    # Views that require extra javascripts or stylesheets should declare them in a :bop_js or :bop_css block.
    # NB. Code editor views have their own layout and don't use this mechanism at all.
    
    def bop_site_tools
      if user_signed_in?
        content_for(:bop_css) { stylesheet_link_tag("bop/site") }
        content_for(:bop_js) {  }
        content_for(:footer) { 
          javascript_include_tag("bop/site")
          render(:partial => 'bop/tools') 
        }
      end
    end
    
    def bop_page_tools
      if user_signed_in?
        content_for(:bop_css) { stylesheet_link_tag("bop/page") }
        content_for(:bop_js) { javascript_include_tag("bop/page") }
      end
    end
    
    
    
    def bop_head
      output = content_for(:head)
      if user_signed_in?
        output << stylesheet_link_tag("bop/site")
        output << content_for(:bop_css)
      end
      output.html_safe
    end

    def bop_body
      output = content_for(:body)
      output.html_safe
    end

    def bop_foot
      output = content_for(:footer)
      if user_signed_in?
        output << render(:partial => 'bop/tools')
        output << javascript_include_tag("bop/site")
        output << content_for(:bop_js)
      end
      output.html_safe
    end

  end
end

