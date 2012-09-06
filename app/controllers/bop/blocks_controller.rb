class Bop::BlocksController < Bop::EngineController
  respond_to :html, :json, :js

  before_filter :authenticate_user!
  
  #todo: These will be replaced with a load_and_authorize_resource call when cancan is hooked up
  before_filter :get_page
  before_filter :get_space
  before_filter :get_block, :only => [:edit, :show, :destroy, :publish, :revert]
  before_filter :build_block, :only => [:new, :create]
  
  layout :set_layout
  
  def index
    @blocks = @page.blocks
    render :partial => 'index', :collection => @blocks, :object => @page
  end

  def new
    respond_with @page, @block
  end

  def create
    @block.save!
    @block.place_on_page(@page, @space)
    respond_with @page, @block
  end

  def show
    respond_with @page, @block
  end

  def edit
    respond_with @page, @block
  end

  def update
    @block.update_attributes(params[:block])
    respond_with @page, @block
  end
  
  def destroy
    head(:ok) if @block.destroy
  end
  
protected

  def get_page
    @page = Bop.site.pages.find(params[:page_id])
  end
  
  def get_space
    @space = params[:space] || 'main'
  end

  def get_block
    @block = @page.blocks.find(params[:id])
  end

  def build_block
    @block = @page.blocks.build(params[:block])
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
