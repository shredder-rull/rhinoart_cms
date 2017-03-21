class CreateSettings < ActiveRecord::Migration[5.0]
  def change
    create_table :rhinoart_settings do |t|
      t.string :name, :limit  => 120, null: false, index: true
      t.string :value, :limit => 65535, default: "", null: false
      t.string :descr, :limit => 65535
    end
  end
end
