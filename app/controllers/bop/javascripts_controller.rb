module Bop
  class JavascriptsController < EngineController
    layout "editor"
    
    respond_to :html, :js
    before_filter :get_javascripts, :only => :index
    before_filter :get_javascript, :only => [:show, :update, :create]
    
    def index
      render :partial => 'index', :collection => @javascripts      
    end
    
    def new
      @javascript = @site.javascripts.new
    end
    
    def create
      @javascript.update_attributes(params[:javascript])
      respond_with @javascript, :location => javascript_url(@javascript)
    end
  
    def show
      respond_with @javascript
    end
    
    def update
      @javascript.update_attributes(params[:javascript])
      respond_with @javascript
    end
    
  protected

    def get_javascript
      @javascript = Javascript.find(params[:id])
    end

    def get_javascripts
      @javascripts = @site.javascripts
    end

  end
end