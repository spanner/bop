require "spec_helper"

describe "Simple page paths" do

  it "routes paths" do
    {:get => "/path/to/page"}.should route_to(
      :controller => "bop/publications",
      :action => "show",
      :path => "path/to/page",
      :format => "html"
    )
  end
  
end
