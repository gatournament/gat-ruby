require "socket"
require "json"

# algorithm = RubyAlgorithm.new
# algorithm.listen
class RubyAlgorithm
  def listen(host='localhost', port=nil)
    unless port
      port = ARGV[0].to_i if ARGV.count > 0
    end
    puts "Random port: #{port}"
    @server = TCPServer.open(port)
    puts "Listening on port #{port}"
    @client = @server.accept
    puts "Client connected"

    @stopped = false
    while not @stopped
      begin
        read_incoming_message
      rescue Exception => e
        puts e
        send_error(e)
        stop
        raise e
      end
    end
    @client.close
    @server.close
  end

  def stop
    @stopped = true
  end

  def read_incoming_message
    message = @client.gets
    message.chomp! if message
    if not message or message == 'stop'
      stop
    else
      message = JSON.parse(message, :symbolize_names => true)
      process_message(message)
    end
  end

  def process_message(message)
    if message[:action] == "play"
      play(message['context'])
    end
  end

  def play(context)
  end

  def send_response(message)
    message = JSON.dump(message)
    message = "#{message}\n"
    @client.puts message
  end

  def send_error(error_message)
    error = {'error' => error_message}
    send_response(error)
  end
end