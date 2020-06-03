class AddDisplayToTeams < ActiveRecord::Migration[4.2]
  def change
    add_column :teams, :display, :string
  end
end
