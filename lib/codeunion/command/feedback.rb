require "codeunion/command/base"
require "codeunion/feedback_request"
require "codeunion/config"

module CodeUnion
  module Command
    class Feedback < Base

      def run
        config = Config.load
        token = config.get("github.api_key")
        repository = config.get("feedback.repository")
        if !token || !repository
          raise CodeUnion::Command::MissingConfig.new(["github.api_key", "feedback.repository"])
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
        raise CodeUnion::Command::InvalidInput.new(input_errors) unless @feedback_request.valid?
      end
    end
  end
end
