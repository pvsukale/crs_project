class AddRankToScore < ActiveRecord::Migration[5.1]
  def change
    add_column :scores, :rank, :integer
  end
end
