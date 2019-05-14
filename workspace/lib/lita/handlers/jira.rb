require 'lita/adapters/slack/message_handler'

# lita-jira plugin
module Lita
  # Because we can.
  module Handlers
    # Main handler
    # rubocop:disable Metrics/ClassLength
    class Jira < Handler
      namespace 'Jira'

      config :username, required: true, type: String
      config :password, required: true, type: String
      config :site, required: true, type: String

      include ::JiraHelper::Issue
      include ::JiraHelper::Misc

      PROJECT_PATTERN = /(?<project>[a-zA-Z0-9]{1,10})/
      ISSUE_PATTERN   = /(?<issue>#{PROJECT_PATTERN}-[0-9]{1,5}+)/

      route(/.*jira\s#{ISSUE_PATTERN}.*/,
        :details,
        command: false,
        help: {t('help.details.syntax') => t('help.details.desc')}
      )

      def details(response)
        issue = fetch_issue(response.match_data['issue'])
        return response.reply(t('error.request')) unless issue
        response.reply(format_issue(issue))
       end
      # rubocop:enable Metrics/AbcSize
    end
    # rubocop:enable Metrics/ClassLength
    Lita.register_handler(Jira)
  end
end
