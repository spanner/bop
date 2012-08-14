ActiveRecord::Schema.define do
  create_table :things, :force => true do |t|
    t.string :title
    t.timestamps
  end
end
