module Bop
  module EngineHelper
    
    def bop_footer
      # if published, etc
      output = ""
      if user_signed_in?
        output << (render :partial => 'bop/tools')
        output << javascript_include_tag("published")
      end
      output
    end

    def bop_header
      # if published, etc
      output = ""
      if user_signed_in?
        output << stylesheet_link_tag("bop")
      end
    end
  end
end
