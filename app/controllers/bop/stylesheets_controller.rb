module Bop
  class StylesheetsController < EngineController
    
    respond_to :html, :css
    before_filter :get_stylesheets, :only => :index
    before_filter :get_stylesheet, :only => [:show, :update]
    
    def index
      render :partial => 'index', :object => @stylesheets      
    end
  
    def show
      respond_with @stylesheet
    end
    
    def new
      @stylesheet = @site.stylesheets.new
      render :partial => 'new', :object => @stylesheet      
    end
    
    def create
      @stylesheet = @site.stylesheets.create(params[:stylesheet])
      render :partial => 'show', :object => @stylesheet
    end
    
    def update
      @stylesheet.update_attributes(params[:stylesheet])
      respond_with @stylesheet, :location => stylesheet_url(@stylesheet)
    end
    
  protected

    def get_stylesheet
      if params[:id]
        @stylesheet = @site.stylesheets.find(params[:id])
      else
        @stylesheet = @site.stylesheets.find_by_slug(params[:slug])
      end
    end

    def get_stylesheets
      @stylesheets = @site.stylesheets
    end

  end
end