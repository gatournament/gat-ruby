require "gat_ruby"

class YourAlgorithm < TrucoAlgorithm
  # You must decide which card of your hand you want to upcard in the table.
  def play(context)
    puts context # to see all information you have to take your decision
    randomDecisionToTruco = Random.rand(1..10)
    if self.can_truco(context) and randomDecisionToTruco > 5
      return self.truco() # only call this method if self.can_truco(context) returns True
    else
      hand = context[:hand][:cards]
      option = Random.rand(0...hand.count)
      random_card = hand[option]
      return self.upcard(random_card)
    end
  end

  # * *Returns* : True or False
  def accept_truco(context)
    return Random.rand(0..1) == 1
  end
end

# Required:
algorithm = YourAlgorithm.new
algorithm.listen