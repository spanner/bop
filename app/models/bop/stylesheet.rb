class Bop::Stylesheet < ActiveRecord::Base
  belongs_to :anchor, :polymorphic => true

end
