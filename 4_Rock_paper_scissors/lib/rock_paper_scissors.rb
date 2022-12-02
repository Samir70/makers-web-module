class RockPaperScissors
  def initialize(v)
    @type = v
    @statements = {
      "Rock-Scissors" => "Rock blunts Scissors. I win!!!",
      "Scissors-Rock" => "Rock blunts Scissors. You win!",

      "Paper-Rock" => "Paper covers Rock. I win!!!",
      "Rock-Paper" => "Paper covers Rock. You win!",

      "Scissors-Paper" => "Scissors cut Paper. I win!!!",
      "Paper-Scissors" => "Scissors cut Paper. You win!",
    }
  end

  def compare(v)
    if @type == v
        return v == "Rock" ? "Rocks smash each other to pieces. We both loose. Why does it have to be like this?!" : "It's a draw"
    end
    pair = [@type, v].join('-')
    return @statements[pair]
  end

  def value
    return @type
  end
end
