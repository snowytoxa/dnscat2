##
# ui_session_command.rb
# By Ron Bowes
# Created May, 2014
#
# See LICENSE.txt
##

require 'command_packet_stream'
require 'command_packet'

class UiSessionCommand < UiInterface
  def initialize(local_id, session, ui)
    super()

    @local_id = local_id
    @session  = session
    @ui = ui
    @stream = CommandPacketStream.new()
    @command_id = 0x0001
  end

  def feed(data)
    @stream.feed(data, false) do |packet|
      puts(packet.to_s)
    end
  end

  def output(str)
    if(attached?())
      puts()
      puts(str)
      print(">> ")
    end
  end

  def error(str)
    if(attached?())
      $stderr.puts()
      $stderr.puts(str)
      print(">> ")
    end
  end

  def to_s()
    if(@state.nil?)
      idle = Time.now() - @last_seen
      if(idle > 60)
        return "session %5d :: %s :: [idle for over a minute; probably dead]" % [@local_id, @session.name]
      elsif(idle > 5)
        return "session %5d :: %s :: [idle for %d seconds]" % [@local_id, @session.name, idle]
      else
        return "session %5d :: %s" % [@local_id, @session.name]
      end
    else
      return "session %5d :: %s :: [%s]" % [@local_id, @session.name, @state]
    end
  end

  def command_id()
    id = @command_id
    @command_id += 1
    return id
  end

  def go
    line = Readline::readline("dnscat [command: #{@local_id}]> ", true)

    if(line.nil?)
      return
    end

    if(line =~ /ping/)
      puts("Attempting to send ping")
      packet = CommandPacket.create_ping_request(command_id(), "A"*200)
      @session.queue_outgoing(packet)
    else
      error("Nope")
    end

    # Queue our outgoing data
    #@session.queue_outgoing(line)
  end
end