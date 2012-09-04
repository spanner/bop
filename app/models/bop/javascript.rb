class Bop::Javascript < ActiveRecord::Base
  belongs_to :anchor, :polymorphic => true

end

