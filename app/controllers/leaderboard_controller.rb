class LeaderboardController < ApplicationController
    def index
    end

    def show
        # TODO: @leaderboard = Leaderboard.find(params[:id])
    end

    def get_by_redirect
        redirect_to "/leaderboard/" + params[:id]
    end
end