class PublicationRoute < ActiveRecord::Migration
  def change
    add_column :publications, :route, :string
  end
end
