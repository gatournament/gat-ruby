
class TrucoAlgorithm < GameAlgorithm
  def process_message(message)
    if message[:action] == "play"
      play(message[:context])
    elsif message[:action] == "accept_truco"
      accept = accept_truco(message[:context])
      if accept
        send_response({:action => :accept_truco})
      else
        send_response({:action => :giveup_truco})
      end
    end
  end

  def play(context)
  end

  def accept_truco(context)
  end

  def can_truco(context)
    return context[:round_value].to_i > 12
  end

  def upcard(card)
    send_response({:action => :upcard, :hand_card => card})
  end

  def truco()
    send_response({:action => :truco})
  end
end