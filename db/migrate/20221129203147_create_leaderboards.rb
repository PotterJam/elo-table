class CreateLeaderboards < ActiveRecord::Migration[7.0]
  def change
    create_table :leaderboards do |t|
      t.string :name
      t.string :player
      t.integer :elo

      t.timestamps
    end
  end
end
