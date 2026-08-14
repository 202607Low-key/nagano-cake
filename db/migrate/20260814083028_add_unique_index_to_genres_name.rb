class AddUniqueIndexToGenresName < ActiveRecord::Migration[8.0]
  def change
    add_index :genres, :name, unique: true
  end
end
