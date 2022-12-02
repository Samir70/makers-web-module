class Rock
  def initialize
    @value = "Rock"
  end

  def compare(v)
    case v
    when "Paper"
      "Paper covers Rock. You win!"
    when "Scissors"
      "Rock blunts Scissors. I win!!!"
    else
      "Rocks smash each other to pieces. We both loose. Why does it have to be like this?!"
    end
  end

  attr_reader :value
end

class Paper
  def initialize
    @value = "Paper"
  end

  def compare(v)
    case v
    when "Rock"
      "Paper covers Rock. I win!!!"
    when "Scissors"
      "Scissors cut Paper. You win!"
    else
      "It's a draw"
    end
  end

  attr_reader :value
end

class Scissors
  def initialize
    @value = "Scissors"
  end

  def compare(v)
    case v
    when "Paper"
      "Scissors cut Paper. I win!!!"
    when "Rock"
      "Rock blunts scissors. You win!"
    else
      "It's a draw"
    end
  end

  attr_reader :value
end

class RockPaperScissors
  def initialize(v)
    if v == "Rock"
      @type = Rock.new
    elsif v == "Paper"
      @type = Paper.new
    else
      @type = Scissors.new
    end
  end

  def compare(v)
    return @type.compare(v)
  end

  def value
    return @type.value
  end
end
