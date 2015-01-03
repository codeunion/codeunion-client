require "codeunion/command/base"
require "codeunion/api"
require "codeunion/helpers/text"
require "codeunion/search"

require "faraday"
require "rainbow"
require "io/console"

module CodeUnion
  module Command
    # The built-in `codeunion search` command
    class Search < Base
      include CodeUnion::Helpers::Text

      def run
        results.inject([]) do |lines, result|
          lines.push(CodeUnion::Search::ResultPresenter.new(result).to_s)
          lines << format_output("")
        end.join("\n")
      end

      def results
        @results ||= api.search(options)
      end

      private

      def api
        @api ||= CodeUnion::API.new("api.codeunion.io", "v1")
      end
    end
  end
end
