lib_dir = File.join(File.dirname(File.expand_path(__FILE__)), "..", "..", "lib")
test_dir = File.join(File.dirname(File.expand_path(__FILE__)), "..", "..", "test")
$LOAD_PATH.unshift(lib_dir)
$LOAD_PATH.unshift(test_dir)

require "minitest/autorun"
require "fixtures/codeunion_api_search"
require "codeunion/search"

module CodeUnion
  class Search
    # A Fake version of the codeunion API for testing purposes
    class FakeCodeunionAPI
      def search(options)
        Fixtures::CodeUnionAPI.search_results()[options[:query]]
      end
    end

    # Test the Search::ResultPresenter
    class ResultPresenterTest < MiniTest::Test
      include CodeUnion::Helpers::Text
      def results
        FakeCodeunionAPI.new.search({ :query => "REST API" })
      end

      def parse(result)
        # Get rid of line breaks and padding so we're not testing
        # indentation.
        ResultPresenter.new(result).to_s.split("\n").map(&:strip).join(" ")
      end

      def assert_highlights(term, color, result)
        Rainbow.enabled = true
        assert(parse(result).include?(Rainbow(term).color(color)),
               "#{term} was not highlighted #{color} in #{parse(result)}")
        Rainbow.enabled = false
      end

      def assert_content(content, result)
        assert(parse(result).include?(content), "#{parse(result)} did not include #{content}")
      end

      def test_presenter_highlights
        assert_highlights("Example", :red, results[0])
        assert_highlights("linkedout-example", :blue, results[0])
        assert_highlights("api", :blue, results[0])
        assert_highlights(results[0]["url"], :green, results[0])
        assert_highlights(results[0]["description"], :yellow, results[0])
        assert_highlights("REST", :blue, results[1])
      end

      def test_presenter_content
        expected_tags = "tags: ajax, dom-manipulation, javascript, jquery, json, request-routing, ruby, sinatra"
        assert_content(expected_tags, results[0])
        assert_content(results[0]["description"], results[0])
      end
    end
  end
end
