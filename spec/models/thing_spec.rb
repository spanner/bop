require 'spec_helper'

describe Thing do
  
  it 'should be given a root page' do
    create(:thing).root_page.should be_kind_of(Bop::Page)
  end
  
  describe "finding pages" do
    before :each do
      @thing = create :thing
      @root = @thing.root_page
      @child = create :child, :parent => @root
      @sibling = create :sibling, :parent => @root
    end
    
    it "should return its root page to an empty path" do
      @thing.find_page("").should == @root
    end
    
    it "should find pages by route" do
      @thing.find_page(@child.route).should == @child
      @thing.find_page(@sibling.route).should == @sibling
    end
  end
end