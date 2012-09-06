class HeadAndBody < ActiveRecord::Migration
  def change
    rename_column :bop_templates, :content, :body
    add_column :bop_templates, :head, :text
    rename_column :bop_publications, :rendered_content, :rendered_body
    add_column :bop_publications, :rendered_head, :text
  end
end
