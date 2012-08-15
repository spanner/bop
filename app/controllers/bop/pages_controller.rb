class Bop::PagesController < Bop::EngineController
  respond_to :html, :json

  before_filter :authenticate_user!
  
  #todo: These will be replaced with a load_and_authorize_resource call when cancan is hooked up
  before_filter :get_page, :only => [:edit, :show, :destroy, :publish, :revert]
  before_filter :build_page, :only => [:new, :create]
  before_filter :get_pages, :only => [:index]
  before_filter :update_page, :only => [:update, :create]

  def index
    respond_with @pages
  end

  def show
    respond_with @page
  end

  def new
    respond_with @page
  end

  def create
    respond_with @page
  end

  def edit
    respond_with @page
  end

  def update
    respond_with @page
  end

  def publish
    publication = @page.publish!
    redirect_to @page.route
  end

protected

  def get_page
    @page = @base.pages.find(params[:id])
  end

  def get_pages
    @root_page = @base.root_page
    @pages = @base.pages
  end

  def build_page
    @pages = @base.pages.build(:parent => params[:parent_id])
  end
  
  def update_page
    @page.update_attributes(params[:page])
  end

end
