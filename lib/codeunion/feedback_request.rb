require "uri"
require 'codeunion/github_api'

module CodeUnion
  class FeedbackRequest
    WEB_URL_REGEX = /\A#{URI::regexp(['http', 'https'])}\z/
    GIT_URL_REGEX = /\Agit:\/\/git@github.com:(.*).git/

    DEFAULT_OWNER="codeunion"
    MISSING_ARTIFACT = "You must provide something to provide feedback on"
    INVALID_ARTIFACT = "The artifact provided was not a web URL. We only provide feedback on code hosted online."

    ISSUE_TITLE = "Please give my code feedback. Submitted #{Time.now}"

    attr_reader :artifact

    def initialize(artifact, github_token, feedback_repository, options = {})
      @github_api = options.fetch(:github_api, GithubAPI).new(github_token)
      @artifact = artifact
      @feedback_repository = FeedbackRepository.coerce_to_proper_url(feedback_repository)
    end

    def send!
      @github_api.create_issue(ISSUE_TITLE, @artifact, @feedback_repository)
    end

    def valid?
      errors.empty?
    end

    def errors
      errors = []
      errors.push(MISSING_ARTIFACT) if artifact.empty?
      errors.push(INVALID_ARTIFACT) unless is_url?(artifact)

      errors.join("\n")
    end

    private
    def is_url?(url)
      url =~ WEB_URL_REGEX
    end

    class FeedbackRepository
      def self.coerce_to_proper_url(location)
        self.new(location).to_s
      end

      def initialize(location)
        @location = clean_up(location)
      end

      def to_s
        extract_owner_and_repo
      end

      private
      def has_owner?
        @location.split(/\//).length == 2
      end

      def extract_owner_and_repo
        if @location =~ WEB_URL_REGEX
          clean_up(URI(@location).path)
        elsif @location =~ GIT_URL_REGEX
          match = @location.match(GIT_URL_REGEX)
          match.captures[0]
        elsif has_owner?
          @location
        else
          prepend_default_owner
        end
      end

      def prepend_default_owner
        "#{DEFAULT_OWNER}/#{@location}"
      end

      def clean_up(feedback_repository)
        feedback_repository.gsub(/^\//,"")
      end
    end
  end
end
