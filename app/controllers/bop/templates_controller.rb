module Bop
  class TemplatesController < EngineController
    layout "bop/editor"
    
    respond_to :html, :css
    before_filter :get_templates, :only => :index
    before_filter :get_template, :only => [:show, :update]
    
    def index
      render :partial => 'index', :object => @templates
    end
  
    def show
      respond_with @template
    end
    
    def new
      @template = @site.templates.new
      render :partial => 'new', :object => @template      
    end
    
    def create
      @template = @site.templates.create(params[:template])
      render :partial => 'show', :object => @template
    end
    
    def update
      @template.update_attributes(params[:template])
      respond_with @template, :location => template_url(@template)
    end
    
  protected

    def get_template
      @template = Template.find(params[:id])
    end

    def get_templates
      @templates = @site.templates
    end

  end
end