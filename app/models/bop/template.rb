class Bop::Template < ActiveRecord::Base
  attr_accessible :title, :content

  belongs_to :user
  has_many :pages

  def compiled
    @template ||= Liquid::Template.parse(content)
  end

end
