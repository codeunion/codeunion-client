require "codeunion"
require "codeunion/command"

class CodeUnion::CLI
  def self.start(*args)
    subcommand = args.shift.strip

    CodeUnion::Command.new(subcommand, *args).exec!
  end
end
