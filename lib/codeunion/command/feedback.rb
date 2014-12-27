require "codeunion/command/base"
require "codeunion/feedback_request"
require "codeunion/config"

module CodeUnion
  module Command
    # "View" in Traditional MVC for the Feedback command. Validates Input
    # and Builds response
    class Feedback < Base
      CREATE_ACCESS_TOKEN_URL =
        "https://help.github.com/articles/creating-an-access-token-for-command-line-use/"

      def run
        config = Config.load
        token = config.get("github.access_token")
        repository = config.get("feedback.repository")
        if !token
          fail(CodeUnion::Command::MissingConfig, { :name => "github.access_token",
                                                    :help => "See: #{CREATE_ACCESS_TOKEN_URL }" })
        elsif !repository
          fail(CodeUnion::Command::MissingConfig, { :name => "feedback.repository" })
        end
        @feedback_request = FeedbackRequest.new(input, token, repository)
        ensure_valid_input!
        @feedback_request.send!
      end

      private

      def input
        options[:input].join("")
      end

      def ensure_valid_input!
        fail(CodeUnion::Command::InvalidInput, @feedback_request.errors) unless @feedback_request.valid?
      end
    end
  end
end
