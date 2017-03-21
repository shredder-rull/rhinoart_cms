class CreatePageFields < ActiveRecord::Migration[5.0]
  def change
    create_table :rhinoart_page_fields do |t|
      t.belongs_to :page, null: false
      t.string :name, limit: 120, null: false
      t.string :value, limit: 65535, index: true
      t.string :type, limit: 20, default: 'string'
    end
    add_index :rhinoart_page_fields, [:page_id, :name], unique: true
  end
end
