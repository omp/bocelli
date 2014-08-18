require 'socket'

module Bocelli
  module Core
    module IRC
      def configure(host, port, nick, pass = nil)
        @host = host
        @port = port
        @nick = nick
        @pass = pass

        @socket = nil
      end

      def connect(&block)
        @socket = TCPSocket.new(@host, @port)

        sputs("PASS #{@pass}") if @pass
        sputs("NICK #{@nick}")
        sputs("USER #{@nick} 0 * :#{@nick}")

        instance_eval(&block) if block_given?
      end

      def sgets
        str = @socket.gets
        str.chomp! unless str.nil?

        puts '<< ' + str.inspect

        str
      end

      def sputs(str)
        puts '>> ' + str.inspect

        @socket.puts(str)
      end

      def pong(message)
        sputs("PONG #{message}")
      end

      def join(channel)
        sputs("JOIN #{channel}")
      end

      def privmsg(channel, message)
        sputs("PRIVMSG #{channel} :#{message}")
      end
    end
  end
end
