require "zmq"
require "json"

# algorithm = GameAlgorithm.new
# algorithm.listen
class GameAlgorithm
  def initialize(name, artist, duration)
    context = ZMQ::Context.new(1)
    @sock = context.socket(ZMQ::REP)
  end

  def listen(host='localhost', port=nil)
    if not port:
        port = sys.argv[1] if len(sys.argv) > 1 else 88888
    end
    @sock.bind("ipc://#{host}:#{port}")
    puts "Listening"
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

  def stop
    @stopped = true
  end

  def read_incoming_message
    message = @sock.recv
    # message = loads(message)
    if message == 'stop'
      stop
    end
    process_message(message)
  end

  def process_message(message)
    if message['action'] == 'play':
      play(message['context'])
    end
  end

  def play(context)
  end

  def send_response(message)
    # message = dumps(message)
    @sock.send(message)
  end

  def send_error(error_message)
    error = {'error' => error_message}
    send_response(error)
  end
end
