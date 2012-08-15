module Bop
  class EngineController < ::ApplicationController
    rescue_from ActiveRecord::RecordNotFound, :with => :rescue_not_found
    rescue_from Bop::PageNotFound, :with => :rescue_not_found
    rescue_from Bop::RootPageNotFound, :with => :rescue_root_page
    before_filter :set_context
  
  protected

    def rescue_not_found
      render :template => 'bop/pages/not_found', :status => :not_found
    end

    def rescue_root_page
      # do something in admin to set up root page
      rescue_not_found
    end
    
    def set_context
      @base = Bop.scope
    end
  end
end