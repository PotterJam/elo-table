class LeaderboardController < ApplicationController
    def index
    end

    def show
        leaderboard = Leaderboard.find_or_create_by(name: params[:name])
        @players = Player.where(leaderboard_id: leaderboard.id).order(elo: :desc)
        @player_names = @players.map(&:name).sort_by(&:downcase)
        @leaderboard_name = params[:name]

        # Let's not talk about this.
        @player_id_to_name = @players.to_h { |p| [p.id, p.name] }
        @games = GameEntry.where(leaderboard_id: leaderboard.id, winner: true).order(created_at: :desc)
    end

    def get_by_redirect
        redirect_to "/leaderboard/" + params[:name]
    end

    def add_player
        leaderboard = Leaderboard.find_by(name: params[:leaderboard_name])
        Player
          .where(name: params[:player_name], leaderboard_id: leaderboard.id)
          .first_or_create(elo: 1400)

        redirect_back fallback_location: root_path
    end

    def add_entry
        winner_name, loser_name = params[:winner_name], params[:loser_name]

        if winner_name == loser_name
            return
        end

        leaderboard = Leaderboard.find_by(name: params[:leaderboard_name])

        # I'll implement draws when we get one
        winner = Player.where(:name => winner_name, :leaderboard_id => leaderboard.id).first
        loser = Player.where(:name => loser_name, :leaderboard_id => leaderboard.id).first

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

        newWinnerElo, newLoserElo = Elo.calculate_from_result(winner.elo, loser.elo, 1)

        winner.update(elo: newWinnerElo)
        loser.update(elo: newLoserElo)

        redirect_back fallback_location: root_path
    end
end