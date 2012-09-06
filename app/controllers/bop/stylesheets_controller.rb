module Bop
  class StylesheetsController < EngineController
    layout "editor"
    
    respond_to :html, :css
    before_filter :get_stylesheets, :only => :index
    before_filter :get_stylesheet, :only => [:show, :update, :create]
    
    def index
      render :partial => 'index', :collection => @stylesheets      
    end
  
    def show
      respond_with @stylesheet
    end
    
    def create
      @stylesheet.update_attributes(params[:stylesheet])
      respond_with @stylesheet, :location => stylesheet_url(@stylesheet)
    end
    
    def new
      @stylesheet = @site.stylesheets.new
    end
    
    def update
      @stylesheet.update_attributes(params[:stylesheet])
      respond_with @stylesheet, :location => stylesheet_url(@stylesheet)
    end
    
  protected

    def get_stylesheet
      @stylesheet = Stylesheet.find(params[:id])
    end

    def get_stylesheets
      @stylesheets = @site.stylesheets
    end

  end
end