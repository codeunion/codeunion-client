require "codeunion/command/base"
require "ptools"

module CodeUnion
  module Command
    # The built-in main `codeunion` command
    class Main < Base
      def run
        if exist?
          exec(executable_name, *command_args)
        else
          fail CommandNotFound, "Unknown command `#{command_name}`."
        end
      end

      def exist?
        File.which(executable_name)
      end

      private

      def command_name
        options[:command_name]
      end

      def command_args
        options[:command_args]
      end

      def executable_name
        "codeunion-#{command_name}"
      end
    end
  end
end
