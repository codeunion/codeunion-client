require "codeunion/command/base"
require "codeunion/api"

require "faraday"
require "rainbow"

module CodeUnion
  module Command
    # The built-in `codeunion search` command
    class Search < Base
      def run
        results_by_category.flat_map do |name, results|
          heading = Rainbow("#{name.capitalize}:").color(:red)

          results.inject([heading]) do |lines, result|
            lines << indent(Rainbow(result["url"]).color(:green))
            lines << indent("tags: ") + result["tags"].sort.join(", ")
            lines << indent(result["description"])
            lines << indent("")
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

      def indent(str, level = 1)
        ("  " * level) + str
      end

      def api
        @api ||= CodeUnion::API.new("api.codeunion.io", "v1")
      end
    end
  end
end
