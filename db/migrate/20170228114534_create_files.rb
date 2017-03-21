class CreateFiles < ActiveRecord::Migration[5.0]
  def change
    create_table :rhinoart_files do |t|
      t.references :owner, polymorphic: true
      t.string :file
      t.string :file_content_type
      t.timestamps
    end
  end
end
