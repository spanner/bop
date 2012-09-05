class Bop::BlocksController < Bop::EngineController
  respond_to :html, :json, :js

  before_filter :authenticate_user!
  
  #todo: These will be replaced with a load_and_authorize_resource call when cancan is hooked up
  before_filter :get_page
  before_filter :get_block, :only => [:edit, :show, :destroy, :publish, :revert]
  before_filter :build_block, :only => [:new, :create]
  before_filter :update_block, :only => [:update, :create]
  
  layout :set_layout
  

  def new
    respond_with @block
  end

  def create
    respond_with @block
  end

  def show
    respond_with @block
  end

  def edit
    respond_with @block
  end

  def update
    respond_with @block
  end
  
  def destroy
    respond_with @block.destroy
  end
  
protected

  def get_page
    @page = Bop.site.pages.find(params[:page_id])
  end

  def get_block
    @block = @page.blocks.find(params[:id])
  end

  def build_block
    @block = @page.blocks.build
  end

  def update_block
    @block.update_attributes(params[:block])
  end

private

  def set_layout
    if request.headers['X-PJAX']
      false
    else
      "bop"
    end
  end

end
