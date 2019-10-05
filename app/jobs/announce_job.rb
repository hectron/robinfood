class AnnounceJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    decision = Recommendations::Engines::V2.new(Date.current).generate
    SlackAdapter.announce(decision, channel: '#app-robinhood')
  end
end
