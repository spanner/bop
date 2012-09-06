module Bop
  class StylesheetsController < EngineController
    layout "editor"
    
    respond_to :html, :css
    before_filter :get_stylesheets, :only => :index
    before_filter :get_stylesheet, :only => [:show, :update]
    
    def index
      render :partial => 'index', :collection => @stylesheets      
    end
  
    def show
      respond_with @stylesheet
    end
    
    def update
      @stylesheet.update_attributes(params[:stylesheet])
      respond_with @stylesheet
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