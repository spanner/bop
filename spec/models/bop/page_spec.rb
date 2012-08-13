require 'spec_helper'

describe Bop::Page do
  
  before do
    @page = FactoryGirl.create(:page)
    @child = FactoryGirl.create(:child, :parent => @page)
    @grandchild = FactoryGirl.create(:grandchild, :parent => @child)
    @sibling = FactoryGirl.build(:sibling)
  end
  
  describe 'should test ancestry' do
    it "so a new child page gets the right ancestors and path" do
      @grandchild.ancestry.should eq "#{@page.id}/#{@child.id}"
    end
    it "moving the page to a different parent sets its ancestry correctly" do
      @sibling.slug = "sibling"
      @sibling.save!
      @grandchild.parent = @sibling
      @grandchild.ancestry.should eq "#{@sibling.id}"
    end
  end
  
  describe 'inheritance of context' do
    it "new child page has its route set" do
      @grandchild.route.should eq "#{@page.slug}/#{@child.slug}/#{@grandchild.slug}"
    end
    it "new child page inherits the anchor from its parent" do
      @page.anchor.should_not eq nil
      @child.anchor.should eq @page.anchor
    end
  end
  
  describe 'propogation of context' do
    it "change the slug of a grandparent page and all its descendants should have their routes updated" do
      @page.slug = "new"
      @page.save!
      @child.route.should eq "new/child"
      @grandchild.route.should eq "new/child/grandchild"
    end
  end
  
  describe 'validation' do
    it "not valid without a title" do
      @page.should be_valid
      @page.title = nil
      @page.should_not be_valid
    end
    it "not valid with a slug that is already in use by one of its siblings" do
      expect{ @sibling.save! }.to raise_error
    end
  end
  
  describe 'rendering' do
    it "should have a template" do
      @page.template_id.should_not eq nil
    end
    it "should have an inherited template if none of its own" do
      @child.template_id == nil
      @child.inherited_template.should eq @page.template
    end
    it "should provide context" do
      #####
      
    end
    it "should render correctly" do
      #####
    end
  end
  
  describe 'publication' do
    it "should save a render snapshot" do
      ####
    end
  end
  
end