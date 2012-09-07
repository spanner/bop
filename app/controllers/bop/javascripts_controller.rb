module Bop
  class JavascriptsController < EngineController
    
    respond_to :html
    respond_to :js, :only => :show
    before_filter :get_javascripts, :only => :index
    before_filter :get_javascript, :only => [:show, :update]
    
    def index
      render :partial => 'index', :object => @javascripts      
    end
    
    def show
      respond_with @javascript
    end
  
    def new
      @javascript = @site.javascripts.new
      render :partial => 'new', :object => @javascript      
    end
    
    def create
      @javascript = @site.javascripts.create(params[:javascript])
      render :partial => 'show', :object => @javascript
    end
    
    def update
      @javascript.update_attributes(params[:javascript])
      respond_with @javascript
    end
    
  protected

    def get_javascript
      if params[:id]
        @javascript = @site.javascripts.find(params[:id])
      else
        @javascript = @site.javascripts.find_by_slug(params[:slug])
      end
    end

    def get_javascripts
      @javascripts = @site.javascripts
    end

  end
end