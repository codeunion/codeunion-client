require "rainbow"
require "codeunion/helpers/text"

module CodeUnion
  class Search
    # Prepares a search result for presentation in the CLI
    class ResultPresenter
      include CodeUnion::Helpers::Text
      EXCERPT_REGEX = /<match>([^<]*)<\/match>/

      def initialize(result)
        @result = result
      end

      def to_s
        [:description, :url, :tags, :excerpt].map do |attribute|
          format_output(send(attribute))
        end.join("\n")
      end

      private

      def description
        Rainbow(@result["description"]).color(:yellow)
      end

      def excerpt
        "excerpt: " + @result["excerpt"].gsub(EXCERPT_REGEX) do
          query_term = Regexp.last_match[1]
          Rainbow(query_term).color(:blue)
        end + "..."
      end

      def url
        Rainbow(@result["url"]).color(:green)
      end

      def tags
        "tags: " + @result["tags"].sort.join(", ")
      end
    end
  end
end
