require "rock_paper_scissors"

RSpec.describe RockPaperScissors do
  it "initialises with a value" do
    rps = RockPaperScissors.new("Rock")
    expect(rps.value).to eq "Rock"
    rps = RockPaperScissors.new("Paper")
    expect(rps.value).to eq "Paper"
    rps = RockPaperScissors.new("Scissors")
    expect(rps.value).to eq "Scissors"
  end
  describe "#compare" do
    it "declares a draw when values are the same" do
      rps = RockPaperScissors.new("Rock")
      expect(rps.compare("Rock")).to eq "Rocks smash each other to pieces. We both loose. Why does it have to be like this?!"
      rps = RockPaperScissors.new("Paper")
      expect(rps.compare("Paper")).to eq "It's a draw"
      rps = RockPaperScissors.new("Scissors")
      expect(rps.compare("Scissors")).to eq "It's a draw"
    end
    it "declares that Scissors < Rock < Paper" do
      rps = RockPaperScissors.new("Rock")
      expect(rps.compare("Paper")).to eq "Paper covers Rock. You win!"
      expect(rps.compare("Scissors")).to eq "Rock blunts Scissors. I win!!!"
    end
    it "declares that Rock < Paper < Scissors" do
      rps = RockPaperScissors.new("Paper")
      expect(rps.compare("Rock")).to eq "Paper covers Rock. I win!!!"
      expect(rps.compare("Scissors")).to eq "Scissors cut Paper. You win!"
    end
    it "declares that Paper < Scissors < Rock" do
      rps = RockPaperScissors.new("Scissors")
      expect(rps.compare("Paper")).to eq "Scissors cut Paper. I win!!!"
      expect(rps.compare("Rock")).to eq "Rock blunts scissors. You win!"
    end
  end
end
