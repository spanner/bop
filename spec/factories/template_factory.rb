FactoryGirl.define do

  factory :template, :class => "Bop::Template" do
    markup_type "liquid"
    content "{{foo}}"
    
    factory :basic_template do
      title "basic"
      content "<h1>{{page.title}}</h1>"
    end
    
    factory :fancy_template do
      title "fancy"
      content "<h1>{{page.title}} is fancy</h1>"
    end
  end
end
