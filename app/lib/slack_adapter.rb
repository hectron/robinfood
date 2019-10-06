require 'slack'

class SlackAdapter
  TOKEN = ENV.fetch('SLACK_TOKEN').freeze

  class << self
    def announce(decision, channel:)
      client.files_upload(
        channels: channel,
        as_user:  true,
        filename: "#{decision.date.to_formatted_s(:number)}_recommendation.md",
        filetype: 'post',
        content:  decision.content
      )
    end

    private

    def client
      Slack::Web::Client.new(token: TOKEN)
    end
  end
end