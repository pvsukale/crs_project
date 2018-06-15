class AddInfoToColleges < ActiveRecord::Migration[5.1]
  def change
    add_column :colleges, :address, :text
    add_column :colleges, :website, :string
    add_column :colleges, :description, :text
    add_column :colleges, :image_url, :string
  end
end
