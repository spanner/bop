class Bop::PagesController < Bop::EngineController

  before_filter :authenticate_user!
  load_and_authorize_resource :class => "Bop::Page"

  def index
    respond_with @pages
  end

  def show
    respond_with @page
  end

  def publish
  
  end

  def revert
  
  end

protected



end
