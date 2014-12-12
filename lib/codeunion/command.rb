require "codeunion"

module CodeUnion
  module Command
    class CommandNotFound < StandardError; end
    class MissingConfig < StandardError;
      def initialize(required_fields)
        super("Make sure you've `codeunion config --set` the following config variables: #{required_fields.join", "}")
      end

    end
    class InvalidInput < StandardError; end
  end

end
