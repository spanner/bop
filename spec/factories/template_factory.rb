FactoryGirl.define do

  factory :template, :class => "Bop::Template" do
    markup_type "liquid"
    content "{{foo}} is a {{bar}}"
  end
  factory :basic_template, :class => "Bop::Template" do
    title "basic"
  end

end
