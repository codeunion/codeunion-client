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
        args.first
      end

      def command_args
        args.drop(1)
      end

      def executable_name
        "codeunion-#{command_name}"
      end
    end
  end
end
