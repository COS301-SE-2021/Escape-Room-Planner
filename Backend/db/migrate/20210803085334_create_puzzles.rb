class CreatePuzzles < ActiveRecord::Migration[6.1]
  def change
    create_table :puzzles do |t|
      t.string :description
      t.time :estimatedTime

      t.timestamps
    end
  end
end
