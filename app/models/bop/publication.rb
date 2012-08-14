class Bop::Publication < ActiveRecord::Base
  belongs_to :page
  belongs_to :user
  default_scope order("created_at DESC")
end
