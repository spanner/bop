require 'spec_helper'

describe Bop::Template do
  
  before do
    @template = FactoryGirl.create(:template)
  end
  
  describe 'rendering' do
    describe "if markup_type is liquid" do
      it "render_class is Bop::LiquidRenderer" do
        @template.render_class.should eq Bop::LiquidRenderer
      end
      it "renderer is a Liquid template" do
        ####
      end
      it "" do
        ####
      end
    end
  end
  
end