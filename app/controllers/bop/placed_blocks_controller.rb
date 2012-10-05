class Bop::PlacedBlocksController < Bop::EngineController
  respond_to :html, :json, :js
  before_filter :get_page
  
  
  def update
    @placed_block = @page.placed_blocks.find(params[:id])
    @placed_block.update_attributes(params[:placed_block])
    @placed_block.save!
    respond_with @page, @placed_block
  end
  
  def get_page
    @page = Bop.site.pages.find(params[:page_id])
  end

end
