class CreateGameEntries < ActiveRecord::Migration[7.0]
  def change
    create_table :game_entries do |t|
      t.references :leaderboard, null: false, foreign_key: true
      t.references :player, null: false, foreign_key: false
      t.references :versus, null: false, foreign_key: false
      t.boolean :winner
      t.integer :player_elo

      t.timestamps
    end
    add_foreign_key :game_entries, :players, column: :player_id
    add_foreign_key :game_entries, :players, column: :versus_id
  end
end
