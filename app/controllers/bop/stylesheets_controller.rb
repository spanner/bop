module Bop
  class StylesheetsController < EngineController
    respond_to :html
  
    def index
      if @anchor = Bop.scope
        render
      end
    end
  
    def show
      @stylesheet = Stylesheet.find(params[:id])
      respond_with @stylesheet
    end
    
  protected

    def update_stylesheet
      @stylesheet.update_attributes(params[:id])
    end
  end
end