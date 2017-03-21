class CreatePages < ActiveRecord::Migration[5.0]
  def change
    create_table :rhinoart_pages do |t|
      t.references :parent
      t.belongs_to :user

      t.string :name, null: false
      t.string :slug, null: false, unique: true, index: :unique

      t.integer :lft, null: false, index: true
      t.integer :rgt, null: false, index: true

      # optional fields
      t.integer :depth, null: false, default: 0
      t.integer :children_count, null: false, default: 0

      t.boolean :menu, default: false
      t.boolean :active, default: true
      t.string  :type,  limit: 20, default: "page", null: false, index: true

      t.integer :comments_count, default: 0
      t.text :images

      t.timestamps
      t.datetime :published_at
    end
  end
end
