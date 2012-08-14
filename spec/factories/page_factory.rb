FactoryGirl.define do

  factory :page, :class => "Bop::Page" do
    title "Page"
    sequence(:slug) {|n| "page_#{n}" }
    template :factory => :basic_template

    factory :root_page do
      title "Root"
      slug ""
      after(:create) { |page|
        page.anchor = FactoryGirl.create(:thing)
        page.save
      }
    end
    
    factory :child do
      title "Child"
      sequence(:slug) {|n| "child_#{n}" }
      template :factory => :fancy_template
    end

    factory :sibling do
      title "Sibling" 
      sequence(:slug) {|n| "sibling_#{n}" }
    end

    factory :grandchild do
      title "Grandchild"
      sequence(:slug) {|n| "grandchild_#{n}" }
    end

    factory :greatgrandchild do
      title "Great Grandchild"
      sequence(:slug) {|n| "great_grandchild_#{n}" }
    end
    
  end
end
