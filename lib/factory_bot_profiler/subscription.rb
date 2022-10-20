module FactoryBotProfiler
  class Subscription
    attr_reader :stats

    def initialize(stats)
      @stats = stats
    end

    def subscribe
      @subscription = ActiveSupport::Notifications.subscribe(
        "factory_bot.run_factory",
        FactoryBotProfiler::Subscriber.new(stats)
      )
      self
    end

    def unsubscribe
      ActiveSupport::Notifications.unsubscribe(@subscription) if @subscription
      @subscription = nil
    end
  end
end
