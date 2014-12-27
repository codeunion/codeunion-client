require "codeunion/command/base"
require "codeunion/config"
require "fileutils"

module CodeUnion
  module Command
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
