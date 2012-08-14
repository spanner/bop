module Bop
  class PublicationsController < ApplicationController
    
    def index
      
    end

    def show
      @anchor = Bop.scope
      @path = normalize_path(params[:path])
      @page = @anchor.find_page(@path)
      @publication = @page.latest if @page
      raise Bop::PageNotFound unless @publication
      render :text => @publication.rendered_content
    end

  protected
  
    def normalize_path(path)
      "/#{path}".gsub(/\/{2,}/, "/")
    end
  end
end