require "codeunion"

module CodeUnion
  module Command
    # Raised when a command doesn't exist
    class CommandNotFound < StandardError; end

    # Raised when a command is missing required configuration fields
    #
    # Example:
    #   fail(MissingConfig, {
    #                         :name => "codeunion.api_token",
    #                         :help => "See: http://codeunion.com/guides/creating-a-codeunion-access-token"
    #                       }
    class MissingConfig < StandardError
      def initialize(field)
        super("Run 'codeunion config set #{field[:name]} VALUE'#{help_text(field)}")
      end

      def help_text(field)
        field[:help] ? "\n#{field[:help]}" : ""
      end
    end

    # Raised when input isn't appropriate for a command
    class InvalidInput < StandardError; end
  end
end
