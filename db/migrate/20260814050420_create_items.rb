class CreateItems < ActiveRecord::Migration[8.0]
  def change
    create_table :items do |t|
      t.boolean :is_active, default: true, null: false
      t.string :name
      t.text :introduction
      t.integer :price
      t.references :genre, null: false, foreign_key: true

      t.timestamps
    end
  end
end
