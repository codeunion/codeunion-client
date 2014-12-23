lib_dir = File.join(File.dirname(File.expand_path(__FILE__)), "..", "..", "lib")
$LOAD_PATH.unshift(lib_dir)

require "minitest/autorun"
require "codeunion/search"

module CodeUnion
  class Search
    # A Fake version of the codeunion API for testing purposes
    class FakeCodeunionAPI
      def search(options)
        if options[:query] == "REST API"
          [{
            "name"        => "linkedout-example",
            "description" => "Example code for codeunion/linkedout: a one-page resume management system.",
            "private"     => true,
            "url"         => "https://github.com/codeunion/linkedout-example",
            "category"    => "examples",
            "tags"        => ["ruby", "sinatra", "javascript", "jquery", "ajax", "request-routing", "json", "dom-manipulation"],
            "access"      => ["students", "staff"],
            "license"     => true,
            "has_wiki"    => false,
            "notes"       => "",
            "excerpt"     => "<match>api</match>-post]:http://api.jquery.com/jquery.post/\n[jquery-<match>api</match>-append]:http://api.jquery.com/append/\n[jquery-<match>api</match>-serialize]:http://api.jquery.com"
          }, {
            "name"        => "overheard-server",
            "description" => "Example project for a web app that stores and shares hilarious, out of context quotess and quips.",
            "private"     =>  false,
            "url"         => "https://github.com/codeunion/overheard-server",
            "category"    => "examples",
            "tags"        => ["ruby", "sinatra", "datamapper", "sqlite"],
            "access"      => ["public", "students", "staff"],
            "license"     => true,
            "has_wiki"    => false,
            "notes"       => "Unclear purpose. Is it an example project or a tool?",
            "excerpt"     => "<match>REST</match> <match>API</match> to add and list Overheards\n\nFor a list of planned and implemented features"
          }]
        end
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
