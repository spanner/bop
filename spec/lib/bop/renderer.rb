require 'spec_helper'

describe Bop::Renderer do
  
  it "should know about the liquid renderer" do
    Bop::Renderer.get('liquid').should eq Bop::LiquidRenderer
    # there should be a Bop::Renderers.get('liquid')
    # it should be a Bop::Renderer::LiquidRenderer
  end
end

describe Bop::LiquidRenderer do
  
  before do
    @template = FactoryGirl.create(:template)
  end

  it "should prepare correctly" do
    @template.renderer.should be_a_kind_of Liquid::Template
  end
  
  it "should render correctly" do
    @template.render("foo" => "bonnie", "bar" => "dog").should eq "bonnie is a dog"
  end
  
end