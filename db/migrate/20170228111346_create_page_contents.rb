class CreatePageContents < ActiveRecord::Migration[5.0]
  def change
    create_table :rhinoart_page_contents do |t|
      t.belongs_to :page
      t.string :name, limit: 100, null: false, index: true
      t.text :content
      t.integer :position, null: false
    end
    add_index :rhinoart_page_contents, [:page_id, :name], :unique => true
  end
end
