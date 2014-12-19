require "uri"
require "codeunion/github_api"
require "addressable/uri"

module CodeUnion
  # Sends feedback requests to CodeUnion for review
  class FeedbackRequest
    WEB_URL_REGEX = /\A#{URI.regexp(['http', 'https'])}\z/

    GIT_URL_REGEX = %r{\A(git://)?git@github.com:(.*)(.git)?\z}
    REPO_CAPTURE_INDEX = 1

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
      errors.push(INVALID_ARTIFACT) unless url?(artifact)

      errors.join("\n")
    end

    private

    def url?(url)
      url =~ WEB_URL_REGEX
    end

    # Ensures a feedback repository location string is usable via the github api
    class FeedbackRepository
      DEFAULT_OWNER = "codeunion"

      def self.coerce_to_proper_url(location)
        new(location).to_s
      end

      def initialize(location)
        @location = CLEAN.call(location)
      end

      def to_s
        extract_owner_and_repo
      end

      private

      CLEAN = ->(location) { location.gsub(/^\//, "").gsub(".git", "") }
      EXTRACTORS = [
        {
          :match => ->(location) { location =~ GIT_URL_REGEX },
          :extract => lambda do |location|
            match = location.match(GIT_URL_REGEX)
            CLEAN.call(match.captures[REPO_CAPTURE_INDEX])
          end
        },
        {
          :match => ->(location) { location =~ WEB_URL_REGEX },
          :extract => ->(location) { CLEAN.call(URI(location).path) }
        },
        {
          :match => ->(location) { location.split(/\//).length == 2 },
          :extract => ->(location) { location }
        },
        {
          :match => ->(_) { true },
          :extract => ->(location) { "#{DEFAULT_OWNER}/#{location}" }
        }
      ]
      def extract_owner_and_repo
        EXTRACTORS.each do |extractor|
          if extractor[:match].call(@location)
            return extractor[:extract].call(@location)
          end
        end
      end
    end
  end
end
