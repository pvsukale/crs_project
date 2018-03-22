class CreateCutoffs < ActiveRecord::Migration[5.1]
  def change
    create_table :cutoffs do |t|
      t.references :college, foreign_key: true
      t.references :branch, foreign_key: true
      t.integer :rank
      t.timestamps
    end
  end
end
