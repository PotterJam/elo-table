class LeaderboardController < ApplicationController
    def index
    end

    def show
        leaderboard = Leaderboard.find_or_create_by(name: params[:name])
        @players = Player.where(leaderboard_id: leaderboard.id).order(elo: :desc)
        @leaderboard_name = params[:name]
    end

    def get_by_redirect
        redirect_to "/leaderboard/" + params[:name]
    end

    def add_entry
        leaderboard = Leaderboard.find_by(name: params[:leaderboard_name])

        def get_or_create_player(name, leaderboard_id)
            return Player
                .where(:name => name, :leaderboard_id => leaderboard_id)
                .first_or_create { |player| player.elo = 1400 }
        end
        
        winner = get_or_create_player(params[:winner_name], leaderboard.id)
        loser = get_or_create_player(params[:loser_name], leaderboard.id)
        
        winner.update(elo: winner.elo + 10)
        loser.update(elo: loser.elo - 10)

        GameEntry.create(
            leaderboard_id: leaderboard.id,
            player_id: winner.id,
            versus_id: loser.id,
            winner: true,
            player_elo: winner.elo)

        GameEntry.create(
            leaderboard_id: leaderboard.id,
            player_id: loser.id,
            versus_id: winner.id,
            winner: false,
            player_elo: loser.elo)

        redirect_back fallback_location: root_path
    end
end