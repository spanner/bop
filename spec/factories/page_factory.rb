FactoryGirl.define do

  factory :page, :class => "Bop::Page" do
    title "Page"
    template :factory => :basic_template
  end
  factory :child, :class => "Bop::Page" do
    title "Child"
  end
  factory :sibling, :class => "Bop::Page" do
    title "Page" 
  end
  factory :grandchild, :class => "Bop::Page" do
    title "Grandchild"
  end
end
