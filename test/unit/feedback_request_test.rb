lib_dir = File.join(File.dirname(File.expand_path(__FILE__)), "..", "..", "lib")
$LOAD_PATH.unshift(lib_dir)

require "minitest/autorun"
require "codeunion/feedback_request"

module CodeUnion
  # Fake version of the GithubAPI that acts as a spy
  class FakeGithubAPI
    @requests = []
    class << self
      attr_reader :requests
    end

    def initialize(access_token)
      @access_token = access_token
    end

    def create_issue(title, content, repository)
      self.class.requests.push({ :type => :create_issue,
                                 :title => title,
                                 :content => content,
                                 :repository => repository,
                                 :token => @access_token })
    end

    def self.last_request
      @requests.last
    end
  end

  # Ensures FeedbackRequest's interacts well with the GithubAPI
  class FeedbackRequestTest < MiniTest::Test
    DEFAULT_ARTIFACT = "http://example.com"
    def send_request(artifact_to_review, repository = "", access_token = "fake_token")
      request = FeedbackRequest.new(artifact_to_review, access_token, repository, { :github_api => FakeGithubAPI })
      request.send!
      request
    end

    def assert_valid_artifact(artifact, msg = "#{artifact} is an invalid artifact")
      request = send_request(artifact)
      assert request.valid?, msg
    end

    def test_web_urls_are_valid_artifacts
      assert_valid_artifact("http://foo.com")
      assert_valid_artifact("https://foo.com")
    end

    def refute_valid_artifact(artifact, msg = "#{artifact} is a valid artifact")
      request = send_request(artifact)
      refute request.valid?, msg
    end

    def test_non_urls_are_not_valid_artifacts
      refute_valid_artifact("ftp://foo.com")
      refute_valid_artifact("foo.com")
      refute_valid_artifact("")
    end

    def test_sending_a_request_for_feedback
      artifact_to_review = DEFAULT_ARTIFACT
      access_token = "fake-token"
      repository = "codeunion/web-fundamentals"

      send_request(artifact_to_review, repository, access_token)

      assert(FakeGithubAPI.last_request[:content].include?(artifact_to_review))
      assert_equal(:create_issue, FakeGithubAPI.last_request[:type])
      assert_equal(access_token, FakeGithubAPI.last_request[:token])
      assert_equal(repository, FakeGithubAPI.last_request[:repository])
      assert_equal(FeedbackRequest::ISSUE_TITLE, FakeGithubAPI.last_request[:title])
    end

    def assert_repository_becomes(expected_repository, input_value)
      send_request(DEFAULT_ARTIFACT, input_value)

      assert_equal(expected_repository, FakeGithubAPI.last_request[:repository])
    end

    def test_repository_prepends_default_owner
      assert_repository_becomes("codeunion/web-fundamentals", "web-fundamentals")
    end

    def test_repository_may_include_non_codeunion_owner
      assert_repository_becomes("zspencer/web-fundamentals", "zspencer/web-fundamentals")
    end

    def test_repository_removes_preceding_forward_slash
      assert_repository_becomes("zspencer/web-fundamentals", "/zspencer/web-fundamentals")
    end

    def test_repository_can_be_github_web_url
      repository = "codeunion/web-fundamentals"
      assert_repository_becomes(repository, "https://github.com/#{repository}")
    end

    def test_repository_can_be_github_web_url_with_dot_git
      repository = "codeunion/web-fundamentals"
      assert_repository_becomes(repository, "https://github.com/#{repository}.git")
    end

    def test_repository_can_be_github_git_url
      repository = "codeunion/web-fundamentals"
      assert_repository_becomes(repository, "git://git@github.com:#{repository}.git")
    end

    def test_repository_can_be_a_github_git_url_without_the_dot_git
      repository = "codeunion/web-fundamentals"
      assert_repository_becomes(repository, "git://git@github.com:#{repository}")
    end

    def test_repository_can_be_a_github_git_url_without_the_protocol
      repository = "codeunion/web-fundamentals"
      assert_repository_becomes(repository, "git@github.com:#{repository}.git")
    end
  end
end
