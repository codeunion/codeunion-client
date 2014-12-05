require "codeunion/command"

module CodeUnion
  module Command
    # A base class for built-in commands
    class Base
      def initialize(options)
        @options = options
      end

      private

      attr_reader :options
    end
  end
end
