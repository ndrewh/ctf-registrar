class AddVisibleToUploads < ActiveRecord::Migration[4.2][5.0]
  def change
    add_column :uploads, :visible, :boolean
  end
end
