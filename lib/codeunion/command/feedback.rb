require "codeunion/command/base"
module CodeUnion
  module Command
    class Feedback < Base
      def run
        puts "SENDING SOME FEEDBACK"
      end
    end
  end

end
