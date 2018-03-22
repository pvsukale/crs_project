class CreateScores < ActiveRecord::Migration[5.1]
  def change
    create_table :scores do |t|
      t.references :college, foreign_key: true
      t.references :branch, foreign_key: true
      t.float :rankk_percentile
      t.float :naac_percetile
      t.float :final_score

      t.timestamps
    end
  end
end
