lib_dir = File.join(File.dirname(File.expand_path(__FILE__)), "..", "..", "lib")
$LOAD_PATH.unshift(lib_dir)

require 'minitest/autorun'
require 'codeunion/feedback_request'


module CodeUnion
  class FakeGithubAPI
    def initialize(access_token)
      @@requests = []
      @access_token = access_token
    end

    def create_issue(title, content, repository)
      @@requests.push({
        type: :create_issue,
        title: title,
        content: content,
        repository: repository,
        token: @access_token
      })
    end

    def self.last_request
      @@requests.last
    end
  end

  class FeedbackRequestTest < MiniTest::Test
    def test_web_urls_are_valid_artifacts
      request = FeedbackRequest.new("http://foo.com", nil, nil)
      assert request.valid?

      request = FeedbackRequest.new("https://foo.com", nil, nil)
      assert request.valid?
    end

    def test_non_urls_are_not_valid_artifacts
      request = FeedbackRequest.new("ftp://foo.com", nil, nil)
      refute request.valid?

      request = FeedbackRequest.new("foo.com", nil, nil)
      refute request.valid?

      request = FeedbackRequest.new("", nil, nil)
      refute request.valid?
    end


    def test_sending_a_request_for_feedback
      artifact_to_review = "http://google.com"
      api_token = "fake-token"
      repository = "codeunion/web-fundamentals"

      request = FeedbackRequest.new(artifact_to_review, api_token, repository, { github_api: FakeGithubAPI })
      request.send!

      assert(FakeGithubAPI.last_request[:content].include?(artifact_to_review))
      assert_equal(:create_issue, FakeGithubAPI.last_request[:type])
      assert_equal(api_token, FakeGithubAPI.last_request[:token])
      assert_equal(repository, FakeGithubAPI.last_request[:repository])
      assert_equal(FeedbackRequest::ISSUE_TITLE, FakeGithubAPI.last_request[:title])
    end
  end
end
