require "codeunion"

module CodeUnion
  module Command
    # Raised when a command doesn't exist
    class CommandNotFound < StandardError; end

    # Raised when input isn't appropriate for a command
    class InvalidInput < StandardError; end
  end
end
