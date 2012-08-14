module Bop
  class PagesController < ApplicationController
    
    def index

    end

    def show_path
      @anchor = Bop.scope
      @page = @anchor.find_path(request.fullpath)
      if @page && publication = @page.latest_publication
        render :text => publication.rendered_content
      else
        head :missing
      end
    end

  end
end
