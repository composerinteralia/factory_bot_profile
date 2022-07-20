# frozen_string_literal: true

require "active_support/notifications"

require_relative "factory_bot_profiler/version"
require_relative "factory_bot_profiler/collector"
require_relative "factory_bot_profiler/subscriber"
require_relative "factory_bot_profiler/reporters/simple_reporter"
require_relative "factory_bot_profiler/reporters/json_reporter"

module FactoryBotProfiler
  def self.subscribe(collector = Collector.new)
    @collector = collector
    subscriber = FactoryBotProfiler::Subscriber.new(@collector)
    ActiveSupport::Notifications.subscribe("factory_bot.run_factory", subscriber)
  end

  def self.report(reporter_class = Reporters::SimpleReporter, output: $stdout)
    reporter_class.new(@collector, output).report if @collector
  end

  def self.merge_and_report(collectors, reporter_class = Reporters::SimpleReporter)
    merged = collectors.reduce(Collector.new, &:merge!)
    reporter_class.new(merged).report
  end
end
