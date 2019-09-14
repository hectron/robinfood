class AnnounceJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    pass
  end
end
