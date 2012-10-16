module Bop
  class PublicationsController < EngineController
    respond_to :html, :rss, :json
    
    def index
      # this is the latest-updates list
    end

    def show
      @path = normalize_path(params[:path])
      @page = @site.find_page(@path)
      @publication = @page.latest if @page
      raise Bop::PageNotFound unless @publication
      render
    end

  end
end