# frozen_string_literal: true

require "active_support/notifications"

require_relative "factory_bot_profiler/version"
require_relative "factory_bot_profiler/collector"
require_relative "factory_bot_profiler/subscriber"
require_relative "factory_bot_profiler/reporters/simple_reporter"

module FactoryBotProfiler
  def self.subscribe(collector_class = Collector)
    @collector = collector_class.new
    subscriber = FactoryBotProfiler::Subscriber.new(@collector)
    ActiveSupport::Notifications.subscribe("factory_bot.run_factory", subscriber)
  end

  def self.report(reporter_class = Reporters::SimpleReporter)
    reporter_class.new(@collector).report if @collector
  end
end
