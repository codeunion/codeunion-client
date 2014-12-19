require "codeunion/command/base"
require "codeunion/api"
require "codeunion/helpers/text"

require "faraday"
require "rainbow"
require "io/console"

module CodeUnion
  module Command
    # The built-in `codeunion search` command
    class Search < Base
      include CodeUnion::Helpers::Text

      def run
        results_by_category.flat_map do |name, results|
          heading = Rainbow("#{name.capitalize}:").color(:red)

          results.inject([heading]) do |lines, result|
            lines << format_output(Rainbow(result["url"]).color(:green))
            lines << format_output("tags: " + result["tags"].sort.join(", "))
            lines << format_output(result["description"])
            lines << format_output("")
          end
        end.join("\n")
      end

      def results_by_category
        results.group_by { |result| result["category"] }.sort
      end

      def results
        api.search(options)
      end

      private

      def format_output(text)
        _rows, cols  = IO.console.winsize
        line_length = [cols, 80].min

        indent(wrap(text, line_length))
      end

      def api
        @api ||= CodeUnion::API.new("api.codeunion.io", "v1")
      end
    end
  end
end
