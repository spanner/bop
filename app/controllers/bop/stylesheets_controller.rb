module Bop
  class StylesheetsController < EngineController
    respond_to :html
    
    before_filter :get_stylesheet, :only => [:show, :update]
  
    def index
      respond_with @stylesheets      
    end
  
    def show
      respond_with @stylesheet
    end
    
  protected

    def get_stylesheet
      @stylesheet = Stylesheet.find(params[:id])
    end

  end
end