# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_11_29_215701) do
  create_table "game_entries", force: :cascade do |t|
    t.integer "leaderboard_id", null: false
    t.integer "player_id", null: false
    t.integer "versus_id", null: false
    t.boolean "winner"
    t.integer "player_elo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["leaderboard_id"], name: "index_game_entries_on_leaderboard_id"
    t.index ["player_id"], name: "index_game_entries_on_player_id"
    t.index ["versus_id"], name: "index_game_entries_on_versus_id"
  end

  create_table "leaderboards", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "players", force: :cascade do |t|
    t.integer "leaderboard_id", null: false
    t.string "name"
    t.integer "elo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["leaderboard_id"], name: "index_players_on_leaderboard_id"
  end

  add_foreign_key "game_entries", "leaderboards"
  add_foreign_key "game_entries", "players"
  add_foreign_key "game_entries", "players", column: "versus_id"
  add_foreign_key "players", "leaderboards"
end
