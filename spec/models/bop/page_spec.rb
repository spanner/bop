require 'spec_helper'

describe Bop::Page do
  
  before :each do
    @page = create(:root_page)
    @child = create(:child, :parent => @page)
    @grandchild = create(:grandchild, :parent => @child)
  end

  describe 'should set ancestry' do
    it "so a new child page gets the right ancestors and path" do
      @grandchild.ancestors.should eq [@page, @child]
    end
    it "moving the page to a different parent sets its ancestry correctly" do
      sibling = create(:sibling, :parent => @page)
      @grandchild.parent = sibling
      @grandchild.save
      @grandchild.ancestors.should eq [@page, sibling]
    end
  end
  
  describe 'propagation of context' do
    it "should call descendants to revise context" do
      ggchild = create(:greatgrandchild, :parent => @grandchild)
      @child.stub(:children).and_return([@grandchild])
      @grandchild.stub(:children).and_return([ggchild])
      @grandchild.should_receive :update_context
      ggchild.should_receive :update_context
      @child.slug = "different"
      @child.save
    end
  end
  
  describe 'inheritance of context' do
    it "should derive its route from the parent" do
      @grandchild.route.should eq "/#{@child.slug}/#{@grandchild.slug}"
    end
    it "should inherit the anchor from its parent" do
      @child.stub(:parent).and_return(@page)
      @child.send :receive_context
      @child.anchor.should_not be_nil
      @child.anchor.should eq @page.anchor
    end
    it "should update its route when receive_context is called" do
      @child.stub(:children).and_return([@grandchild])
      @child.slug = "different_again"
      @child.save
      @grandchild.route.should == "/#{@child.slug}/#{@grandchild.slug}"
    end
  end
  
  describe 'siblings' do
    it "should not include self" do
      sibling = create(:sibling, :parent => @page)
      sibling.siblings.should_not include(sibling)
    end
  end

  describe 'validation' do
    it "not valid without a title" do
      @child.should be_valid
      @child.title = nil
      @child.should_not be_valid
    end
    it "not valid with a slug that is already in use by one of its siblings" do
      sibling = create(:sibling, :parent => @page)
      sibling.slug = @child.slug
      sibling.should_not be_valid
      expect{ sibling.save! }.to raise_error
    end
  end
  
  describe 'rendering' do
    it "should have a template" do
      @page.template_id.should_not be_nil
    end
    it "should have an inherited template if none of its own" do
      @child.inherited_template.should eq @child.template
      @child.template_id = nil
      @child.inherited_template.should eq @page.template
    end
    it "should provide context" do
      thing = create(:thing)
      @child.stub(:anchor).and_return(thing)
      @child.context.should == {
        'page' => @child,
        'thing' => thing,
        'asset' => nil
      }
    end
    it "should render correctly" do
      @child.render.should == %{<h1>#{@child.title} is fancy</h1>}
    end
  end
  
  describe 'publication' do
    it "should save a render snapshot" do
      @child.should_receive(:render).and_return("It's alive!")
      published = @child.publish!
      published.should be_a Bop::Publication
      published.rendered_content.should == "It's alive!"
    end
  end
  
end