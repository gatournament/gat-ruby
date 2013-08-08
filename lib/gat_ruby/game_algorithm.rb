require "logger"
require "socket"
require "json"

# algorithm = GameAlgorithm.new
# algorithm.listen
class GameAlgorithm
  def initialize
    @logger = Logger.new(STDOUT)
    config_log
  end

  def config_log
    @logger.formatter = proc do |severity, datetime, progname, msg|
      "#{msg}\n"
    end
    @logger.level = Logger::INFO
    custom_log_level = nil
    custom_log_level = ARGV[1].to_i if ARGV.count > 1
    if custom_log_level
      if custom_log_level == 10
        @logger.level = Logger::DEBUG
      elsif custom_log_level == 20
        @logger.level = Logger::INFO
      elsif custom_log_level == 30
        @logger.level = Logger::WARN
      elsif custom_log_level == 40
        @logger.level = Logger::ERROR
      elsif custom_log_level == 50
        @logger.level = Logger::FATAL
      end
    end
  end

  def log(message, log_level=Logger::INFO)
    @logger.add(log_level) { "[GATRuby] #{message}" }
  end

  def listen(host='localhost', port=nil)
    unless port
      port = ARGV[0].to_i if ARGV.count > 0
    end
    log "Random port: #{port}", Logger::DEBUG
    @server = TCPServer.open(port)
    log "Listening on port #{port}", Logger::DEBUG
    @client = @server.accept
    log "Client connected", Logger::DEBUG

    @stopped = false
    while not @stopped
      begin
        read_incoming_message
      rescue Exception => e
        log e, Logger::ERROR
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