require "codeunion/command/base"
require "codeunion/feedback_request"
require "codeunion/config"

module CodeUnion
  # Contains all the CodeUnion commands
  module Command
    # "View" in Traditional MVC for the Feedback command. Validates Input
    # and Builds response
    class Feedback < Base
      CREATE_ACCESS_TOKEN_URL =
        "https://help.github.com/articles/creating-an-access-token-for-command-line-use/"

      def run
        feedback_request.send!
      end

      def valid?
        errors.empty?
      end

      def errors
        if configuration_errors.empty?
          feedback_request.errors
        else
          configuration_errors
        end
      end

      private

      def feedback_request
        @feedback_request ||= FeedbackRequest.new(input, token, repository)
      end

      def configuration_errors
        errors = []

        unless token
          errors.push(Config::MissingConfigMessage.new({ :name => "github.access_token",
                                                         :help => "See: #{CREATE_ACCESS_TOKEN_URL }" }).to_s)
        end

        unless repository
          errors.push(Config::MissingConfigMessage.new({ :name => "feedback.repository" }))
        end

        errors
      end

      def config
        @config ||= Config.load
      end

      def token
        @token ||= config.get("github.access_token")
      end

      def repository
        @repository ||= config.get("feedback.repository")
      end

      def input
        options[:input].join("")
      end
    end
  end
end
