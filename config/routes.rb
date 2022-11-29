Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  root "leaderboard#index"

  get "/leaderboard", to: "leaderboard#index"
  get "/leaderboard/:id", to: "leaderboard#show"

  get "/leaderboard-selection-redirect", to:  "leaderboard#get_by_redirect"

end
