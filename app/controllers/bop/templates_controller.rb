module Bop
  class TemplatesController < EngineController
    layout "bop/layouts/editor"
    
    respond_to :html, :css
    before_filter :get_templates, :only => :index
    before_filter :get_template, :only => [:show, :update, :create]
    
    def index
      render :partial => 'index', :collection => @templates
    end
  
    def show
      respond_with @template
    end
    
    def create
      @template.update_attributes(params[:template])
      respond_with @template, :location => template_url(@template)
    end
    
    def new
      @template = @site.templates.new
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