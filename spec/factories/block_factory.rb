FactoryGirl.define do

  factory :block, :class => "Bop::Block" do
    sequence(:title) {|n| "block_#{n}"}
    content "<p>I am a block<p>"
  end
end
