class CreatePageRelations < ActiveRecord::Migration[5.0]
  def change
    create_table :rhinoart_page_relations do |t|
      t.belongs_to :page
      t.references :relation, polymorphic: true
      t.string :key, limit: 20, index: true
      t.integer :position
      t.timestamps
    end
    add_index :rhinoart_page_relations, [:key, :page_id], unique: true
  end
end
