Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  root "leaderboard#index"

  get "/leaderboard", to: "leaderboard#index"
  get "/leaderboard/:name", to: "leaderboard#show"
  get "/leaderboard-selection-redirect", to:  "leaderboard#get_by_redirect"
  post "/leaderboard", to: "leaderboard#add_entry"
  post "/leaderboard/players", to: "leaderboard#add_player"

end
