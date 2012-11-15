module Bop
  class PublicationsController < EngineController
    respond_to :html, :rss, :json, :xml
    before_filter :authenticate_user!, :except => [:index, :latest, :show]

    def index
      # html or xml site map
    end

    def latest
      # latest updates list in rss, json, etc
    end

    def show
      @path = normalize_path(params[:path])
      @publication = @site.find_publication(@path)
      raise Bop::PageNotFound unless @publication
      respond_with @publication
    end

    # Creating rendered publications at view level gives us unforced access to all the helpers and templates.
    def create
      @page = Page.find(params[:page_id])
      @publication = @page.publications.create({
        :head => render_to_string(:partial => "head"),
        :body => render_to_string(:partial => "body"),
      })
      redirect_to @publication.route
    end

    def destroy
      @publication = Publication.find(params[:id])
      @publication.destroy
      redirect_to page_url(@publication.page)
    end

  end
end