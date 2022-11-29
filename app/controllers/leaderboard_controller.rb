class LeaderboardController < ApplicationController
    def index
    end

    def show
        @leaderboard_items = Leaderboard.where(name: params[:name])
        @leaderboard_name = params[:name]
    end

    def get_by_redirect
        redirect_to "/leaderboard/" + params[:name]
    end
end