class Bop::PagesController < Bop::EngineController
  respond_to :html, :json, :js
  layout :bop_layout
  
  before_filter :ensure_there_is_an_admin_user
  before_filter :authenticate_user!
  
  #todo: These will be replaced with a load_and_authorize_resource call when cancan is hooked up
  before_filter :get_page, :only => [:edit, :show, :destroy, :publish, :revert, :update]
  before_filter :build_page, :only => [:new, :create]
  before_filter :get_pages, :only => [:index]
  before_filter :update_page, :only => [:update]


  def index
    respond_with $pages
  end

  def show
    respond_with @page
  end

  def new
    respond_with @page
  end

  def create
    @page.save!
    if request.headers['X-PJAX']
      render :partial => 'page'
    else
      respond_with @page
    end
  end

  def edit
    respond_with @page do |format|
      format.js {render :partial => 'edit'}
    end
  end

  def update
    respond_with @page do |format|
      format.js {render :partial => 'show'}
    end
  end
  
  def destroy
    head(:ok) if @page.destroy
  end

protected

  def get_page
    if params[:path]
      @path = normalize_path(params[:path])
      @page = @site.find_page(@path)
    else
      @page = @site.pages.find(params[:id])
    end
  end

  def get_pages
    @root_page = @site.root_page
    @pages = @site.pages
  end

  def build_page
    @page = @site.build_page(params[:page])
  end
  
  def update_page
    @page.update_attributes(params[:page])
  end
  
  def ensure_there_is_an_admin_user
    raise Bop::AdminNotFound unless Bop.user_class.any?
  end

end
