module Bop
  module EngineHelper
    
    def bop_footer
      output = ""
      if user_signed_in?
        output << render(:partial => 'bop/tools')
        output << javascript_include_tag("bop/bop")
        output << content_for(:bop_js)
      end
      output.html_safe
    end

    def bop_header
      # if published, etc
      output = ""
      output << content_for(:head)
      if user_signed_in?
        output << stylesheet_link_tag("bop/bop")
        output << content_for(:bop_css)
      end
      output.html_safe
    end


    def bop_body
      # if published, etc
      output = ""
      output << content_for(:body)
      output.html_safe
    end

  end
end
