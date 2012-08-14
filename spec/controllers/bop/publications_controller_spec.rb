require "spec_helper"

describe Bop::PublicationsController do
  before :each do
    @root = create(:root_page)
    @child = create(:child, :parent => @root)
    @sibling = create(:sibling, :parent => @root)
    @child.publish!
    Bop.scope = @root.anchor
  end
    
  context "Requesting a page" do
    context "That has been published" do
      before do
        get :show, :path => @child.slug
      end
      
      it { should assign_to(:anchor).with_kind_of(Thing) }
      it { should assign_to(:path).with(@child.route) }
      it { should assign_to(:page).with_kind_of(Bop::Page) }
      it { should respond_with :success }
      it { should respond_with_content_type(:html) }
      
      it "should return the published page" do
        response.body.should == @child.latest.rendered_content
      end
    end
    
    context "That has not been published" do
      before do
        get :show, :path => @sibling.slug
      end
      
      it { should respond_with :not_found }
    end
    
    context "That does not exist" do
      before do
        get :show, :path => "/jabberwock"
      end
  
      it { should respond_with :not_found }
    end
    
  end
  
end