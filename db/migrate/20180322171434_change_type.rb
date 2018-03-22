class ChangeType < ActiveRecord::Migration[5.1]
  def change
    remove_column :colleges, :naac, :string
    add_column :colleges, :naac, :integer
  end
end
