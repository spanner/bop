module Bop
  class AssetsController < ::ApplicationController
    respond_to :js
    before_filter :find_asset, :only => [:show, :edit, :destroy]
    before_filter :build_asset, :only => [:new, :create]

    def show
      respond_with(@asset)
    end

    def new
      render
    end
    
    def index
      # big waterfall of assets with overlaid editing controls
    end

    def create
      @asset.update_attributes(params[:asset])
      render :partial => 'crop'
    end

    def edit
      render :partial => 'crop'
    end
  
    def destroy
      @asset.destroy
      respond_with(@asset)
    end

  private
  
    def find_asset
      @asset = params[:id] == 'latest' || params[:id].blank? ? current_user.last_asset : asset.find(params[:id])
    end
  
    def build_asset
      @asset = asset.create
    end
    
  end
end
