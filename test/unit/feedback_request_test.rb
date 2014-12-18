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
    def send_request(artifact_to_review, repository="", access_token="fake_token")
     request = FeedbackRequest.new(artifact_to_review, access_token, repository, { github_api: FakeGithubAPI })
     request.send!
     request
    end

    def assert_valid_artifact(artifact, msg="#{artifact} is an invalid artifact")
      request = send_request(artifact)
      assert request.valid?, msg
    end

    def test_web_urls_are_valid_artifacts
      assert_valid_artifact("http://foo.com")
      assert_valid_artifact("https://foo.com")
    end

    def refute_valid_artifact(artifact, msg="#{artifact} is a valid artifact")
      request = send_request(artifact)
      refute request.valid?, msg
    end

    def test_non_urls_are_not_valid_artifacts
      refute_valid_artifact("ftp://foo.com")
      refute_valid_artifact("foo.com")
      refute_valid_artifact("")
    end

    def test_sending_a_request_for_feedback
      artifact_to_review = "http://google.com"
      access_token = "fake-token"
      repository = "codeunion/web-fundamentals"

      send_request(artifact_to_review, repository, access_token)

      assert(FakeGithubAPI.last_request[:content].include?(artifact_to_review))
      assert_equal(:create_issue, FakeGithubAPI.last_request[:type])
      assert_equal(access_token, FakeGithubAPI.last_request[:token])
      assert_equal(repository, FakeGithubAPI.last_request[:repository])
      assert_equal(FeedbackRequest::ISSUE_TITLE, FakeGithubAPI.last_request[:title])
    end

    def test_repository_may_be_just_a_repo
     repository = "web-fundamentals"

     send_request("http://google.com", repository)

     assert_equal("codeunion/#{repository}", FakeGithubAPI.last_request[:repository])
   end

   def test_repository_can_include_owner
     repository = "zspencer/web-fundamentals"

     send_request("http://google.com", repository)

     assert_equal(repository, FakeGithubAPI.last_request[:repository])
   end
 end
end