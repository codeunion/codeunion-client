require "codeunion/command/base"
require "codeunion/config"
require "fileutils"

module CodeUnion
  # Contains all the CodeUnion commands
  module Command
    MISSING_NAME  = "You must provide a name to set or unset"
    MISSING_VALUE = "You must provide a value to set"
    # The built-in `codeunion config` command
    class Config < Base
      def run
        edit_config do
          if options[:command] == "get"
            return config.get(options[:input].join(""))
          elsif options[:command] == "set"
            config.set(*options[:input])
          elsif options[:command] == "unset"
            config.unset(options[:input].join(""))
          end
        end
        nil
      end

      def valid?
        errors.length == 0
      end

      def errors
        return @errors if @errors
        @errors = []
        if options[:command] == "set" && options[:input].length != 2
          @errors.push(MISSING_NAME)
          @errors.push(MISSING_VALUE)
        elsif options[:command] == "unset" && options[:input].length == 0
          @errors.push(MISSING_NAME)
        end
        @errors
      end

      private

      def edit_config
        yield
        config.write
      end

      def config
        @config ||= CodeUnion::Config.load
      end
    end
  end
end
