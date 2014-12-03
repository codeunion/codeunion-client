require "codeunion"
require "codeunion/command"

module CodeUnion
  # This class serves as a simple command-line client
  class CLI
    def self.start(*args)
      subcommand = args.shift.strip

      CodeUnion::Command.new(subcommand, *args).exec!
    end
  end
end
