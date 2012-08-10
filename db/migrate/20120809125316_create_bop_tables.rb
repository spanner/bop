class CreateBopTables < ActiveRecord::Migration
  def change
    create_table :bop_pages do |t|
      t.string :title
      t.string :slug
      t.string :route
      t.string :ancestry
      t.integer :template_id
      t.integer :asset_id
      t.integer :user_id
      t.integer :anchor_id
      t.integer :anchor_type
      t.timestamps
    end

    create_table :bop_templates do |t|
      t.string :title
      t.text :content
      t.text :description
      t.string :markup_type
      t.integer :user_id
      t.timestamps
    end

    create_table :bop_blocks do |t|
      t.string :title
      t.text :content
      t.string :markup_type
      t.string :type
      t.integer :asset_id
      t.integer :user_id
      t.timestamps
    end

    create_table :bop_assets do |t|
      t.string :title
      t.has_attached_file :file
      t.integer :user_id
      t.timestamps
    end

    create_table :bop_placed_blocks do |t|
      t.string :space_name
      t.integer :block_id
      t.integer :page_id
      t.timestamps
    end

    create_table :bop_block_properties do |t|
      t.string :name
      t.string :content
      t.timestamps
    end

    create_table :bop_publications do |t|
      t.text :rendered_content
      t.integer :page_id
      t.integer :user_id
      t.timestamps
    end
    
  end
end
