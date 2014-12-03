require "codeunion"
require "ptools"

module CodeUnion
  # This class serves as a simple wrapper around subcommands
  class Command
    class CommandNotFound < StandardError; end

    def initialize(command, *args)
      @command = command
      @args = args
    end

    def exist?
      File.which(executable_name)
    end

    def exec!
      if exist?
        exec(executable_name, *args)
      else
        fail CommandNotFound, "Unknown command `#{@command}`."
      end
    end

    private

    attr_reader :command, :args

    def executable_name
      "codeunion-#{command}"
    end
  end
end
