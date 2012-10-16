module Bop
  class EngineController < ::ApplicationController
    rescue_from "ActiveRecord::RecordNotFound", :with => :rescue_not_found
    rescue_from "Bop::PageNotFound", :with => :rescue_not_found
    rescue_from "Bop::AdminNotFound", :with => :rescue_no_admin
    rescue_from "Bop::SiteNotFound", :with => :rescue_no_site
    before_filter :set_context
    layout :bop_layout

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

  private

    def set_context
      get_site_from_subdomain
      raise Bop::SiteNotFound unless @site = Bop.site
      @base = @site.anchor
      @root_page = @site.root_page
    end
    
    def normalize_path(path)
      "/#{path}".gsub(/\/{2,}/, "/")
    end
  
    def get_site_from_subdomain
      unless Bop.scoped?
        subdomains = request.subdomains
        stem, tld = request.domain.split('.')
        subdomains.push(stem) if tld == 'dev'
        Bop.site = Bop::Site.find_by_slug(subdomains)
      end
    end
  
    def bop_layout
      if request.headers['X-PJAX']
        false
      else
        Bop.layout
      end
    end
    
    def editor_layout
      if request.headers['X-PJAX']
        false
      else
        Bop.editor_layout
      end
    end

    def dashboard_layout
      if request.headers['X-PJAX']
        false
      else
        Bop.dashboard_layout
      end
    end

  end
end