require "codeunion"
require "io/console"

module CodeUnion
  module Helpers
    # Formats text for presenting to a  console
    module Text
      def wrap(text, max_width = IO.console.winsize.last)
        return "" if text.empty?

        words = text.split(/\s+/)
        output = words.shift
        chars_left = max_width - output.length

        words.inject(output) do |output_builder, word|
          if word.length + 1 > chars_left
            chars_left = max_width - word.length
            output_builder << "\n" + word
          else
            chars_left -= word.length + 1
            output_builder << " " + word
          end
        end
      end

      def indent(lines, level = 1)
        lines.split("\n").map { |line| ("  " * level) + line }.join("\n")
      end
    end
  end
end
