class Elo
  def self.calculate_from_result(ratingA, ratingB, result)
    average_rating = (ratingA + ratingB) / 2
    k = getK(average_rating)

    aWinProb = win_probability(ratingA, ratingB)
    bWinProb = win_probability(ratingB, ratingA)

    aScore = result
    bScore = 1 - result

    aNewRating = ratingA + k * (aScore - aWinProb)
    bNewRating = ratingB + k * (bScore - bWinProb)

    return aNewRating, bNewRating
  end

  private

  # copy the USCF
  def self.getK(average_rating)
    case average_rating
    when .. 2100
      return 32
    when 2100 .. 2400
      return 24
    else
      return 16
    end
  end

  def self.win_probability(player_rating, versus_rating)
    return 1.0 / (1 + (10 ** ((versus_rating - player_rating) / 400.0)));
  end
end