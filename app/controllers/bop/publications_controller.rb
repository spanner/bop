module Bop
  class PublicationsController < EngineController
    
    def index
      if @anchor = Bop.scope
        # list of latest updates, in various formats including RSS
        render
      else
        # render bop/home
      end
    end

    def show
      @path = normalize_path(params[:path])
      @page = Bop.find_page(@path)
      @publication = @page.latest if @page
      raise Bop::PageNotFound unless @publication
      render
    end

  end
end