module CodeUnion
  # Runs commands and builds string output from the command
  class CLI
    # Runs a command with the set of options.
    #
    # @param command_type [CodeUnion::Command::Base]
    # @param options [Hash] Options to pass to the command
    # @param help_text [String] Text to append if the command is invalid.
    # @return [String] Multi-line, printable string of the command results.
    def run(command_type, options, help_text = "")
      command = command_type.new(options)
      unless command.valid?
        result = ""
        result << "Woops! Error(s) found!\n"
        result << command.errors.map { |e| "  #{e}" }.join("\n")
        result << "\n"
        result << help_text
        return result
      end
      command.run
    end
  end
end
