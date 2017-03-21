class CreatePageComments < ActiveRecord::Migration[5.0]
  def change
    create_table :rhinoart_page_comments do |t|
      t.belongs_to :user
      t.belongs_to :page
      t.belongs_to :parent

      t.text :body, null: false
      t.boolean :approved, default: false
      t.timestamps
    end
  end
end
