namespace :announcer do
  desc 'Announces decisions to Slack'
  task :run => :environment do
    today = Date.today

    if today.on_weekday?
      channel             = '#app-robinfood'
      budget              = 6
      decision            = Recommendations::Engine::V2.new(Date.today, budget).generate
      vegetarian_decision = Recommendations::Engine::V3.new(Date.today, budget).generate

      if decision.present?
        SlackAdapter.announce(decision, channel: channel)
      else
        Rails.logger.error 'No data found for v2 decision'
      end

      if vegetarian_decision.present?
        SlackAdapter.announce(vegetarian_decision, channel: channel)
      else
        Rails.logger.error 'No data found for vegetarian decision'
      end
    else
      Rails.logger.info 'Not doing anything on a weekend'
    end
  end
end