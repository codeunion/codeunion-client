require "codeunion/command"

module CodeUnion
  module Command
    # A base class for built-in commands
    class Base
      def initialize(*args)
        @args = args
      end

      private

      attr_reader :args
    end
  end
end
