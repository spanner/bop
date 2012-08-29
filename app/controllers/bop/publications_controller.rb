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
      @anchor = Bop.scope
      @path = normalize_path(params[:path])
      logger.warn ">>  path is #{@path.inspect}"
      @page = @anchor.find_page(@path)
      logger.warn ">>  page is #{@page.inspect}"
      @publication = @page.latest if @page
      logger.warn ">>  publication is #{@publication.inspect}"
      raise Bop::PageNotFound unless @publication
      render :text => @publication.rendered_content
    end

  protected

    def normalize_path(path)
      "/#{path}".gsub(/\/{2,}/, "/")
    end
  end
end