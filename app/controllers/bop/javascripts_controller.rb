module Bop
  class JavascriptsController < EngineController
    respond_to :html
  
    def index
      if @anchor = Bop.scope
        render
      end
    end
  
    def show
      @javascript = Javascript.find(params[:id])
      respond_with @javascript
    end
    
  protected

    def update_javascript
      @javascript.update_attributes(params[:id])
    end
  end
end