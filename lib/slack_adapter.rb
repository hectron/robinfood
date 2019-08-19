require 'erb'
require 'slack'


class SlackAdapter
  TOKEN                = ENV.fetch('SLACK_TOKEN')
  AWESOME_DESCRIPTIONS = ['piping hot', 'b r e a t h t a k i n g', 'mouth-watering', 'flippin\' fresh']

  class << self
    def announce(recommendations, channel:)
      file_content = build_recommendation_file(recommendations)

      client.files_upload(
        channels: channel,
        as_user:  true,
        filename: "#{recommendations[:date]}_recommendation.md",
        filetype: 'post',
        content:  file_content
      )
    end

    def build_recommendation_file(recommendations)
      date                = recommendations[:date]
      budget              = recommendations[:budget]
      items               = recommendations[:recommendations]
      awesome_description = AWESOME_DESCRIPTIONS.sample

      filepath = File.join(File.expand_path(File.dirname(__FILE__)), 'templates', 'recommendations.md.erb')
      template = ERB.new(File.read(filepath))

      template.result(binding)
    end

    private

    def client
      Slack::Web::Client.new(token: TOKEN)
    end
  end
end
