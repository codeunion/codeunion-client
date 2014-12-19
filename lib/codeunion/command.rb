require "codeunion"

module CodeUnion
  module Command
    # Raised when a command doesn't exist
    class CommandNotFound < StandardError; end

    # Raised when config does not have required fields for a command
    class MissingConfig < StandardError
      def initialize(required_fields)
        super("Make sure you've `codeunion config --set` the following config variables: #{required_fields.join(", ")}")
      end
    end

    # Raised when input isn't appropriate for a command
    class InvalidInput < StandardError; end
  end
end
