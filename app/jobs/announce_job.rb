require 'slack_adapter'
require 'recommendations'

class AnnounceJob < ActiveJob::Base
  queue_as :default

  def perform(args)
    channel  = args.fetch('channel')
    budget   = args.fetch('budget').to_f
    decision = Recommendations::Engine::V2.new(3.days.from_now, budget).generate

    SlackAdapter.announce(decision, channel: channel)
  end
end
