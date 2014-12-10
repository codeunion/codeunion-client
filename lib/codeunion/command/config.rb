require "codeunion/command/base"
require "codeunion/config"
require "fileutils"

module CodeUnion
  module Command
    # The built-in `codeunion config` command
    class Config < Base

      def run
        edit_config do
          if options[:get]
            return config.get(options[:get])
          elsif options[:set]
            config.set(*options[:set])
          elsif options[:unset]
            config.unset(options[:unset])
          end
        end
        return nil
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
