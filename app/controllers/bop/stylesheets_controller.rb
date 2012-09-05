module Bop
  class StylesheetsController < EngineController
    respond_to :html
    before_filter :get_stylesheets, :only => :index
    before_filter :get_stylesheet, :only => [:show, :update]
    before_filter :update_stylesheet, :only => [:update, :create]
  
    def index
      respond_with @stylesheets
    end
  
    def show
      respond_with @stylesheet
    end
    
    def new
      
    end
    
    def create
      
    end
    
  protected

    def get_stylesheet
      @stylesheet = Stylesheet.find(params[:id])
    end

    def get_stylesheets
      
    end

  end
end