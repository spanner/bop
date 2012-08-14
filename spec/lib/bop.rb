require 'spec_helper'

describe Bop do
  
  it "should get and set a scoping anchor object" do
    thing = create(:thing)
    expect{ Bop.scope = thing}.not_to raise_error
    Bop.scope.should == thing
  end
  
end
