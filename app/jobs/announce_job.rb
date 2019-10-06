class AnnounceJob < ActiveJob::Base
  queue_as :default

  def perform(args)
    channel  = args.fetch('channel')
    budget   = args.fetch('budget').to_f
    decision = Recommendations::Engine::V2.new(Date.today, budget).generate

    SlackAdapter.announce(decision, channel: channel)
  end
end
