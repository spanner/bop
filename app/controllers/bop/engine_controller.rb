module Bop
  class EngineController < ::ApplicationController
    rescue_from "ActiveRecord::RecordNotFound", :with => :rescue_not_found
    rescue_from "Bop::PageNotFound", :with => :rescue_not_found
    rescue_from "Bop::AdminNotFound", :with => :rescue_no_admin
    rescue_from "Bop::SiteNotFound", :with => :rescue_no_site
    before_filter :set_context
    layout :set_layout

  protected

    def rescue_not_found
      render :template => 'bop/pages/not_found', :status => :not_found
    end
    
    def rescue_no_admin
      render :template => 'bop/users/not_found', :status => :not_found
    end
    
    def rescue_no_site
      render :template => 'bop/sites/not_found', :status => :not_found
    end

    def set_context
      raise Bop::SiteNotFound unless @site = Bop.site
      @base = @site.anchor
      @root_page = @site.root_page
    end
    
    def normalize_path(path)
      "/#{path}".gsub(/\/{2,}/, "/")
    end

  private

    def set_layout
      if request.headers['X-PJAX']
        false
      else
        Bop.layout
      end
    end

  end
end