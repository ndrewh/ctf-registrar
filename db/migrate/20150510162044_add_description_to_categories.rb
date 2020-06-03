class AddDescriptionToCategories < ActiveRecord::Migration[4.2]
  def change
    add_column :categories, :description, :text
    add_index :categories, :name, unique: true
  end
end
