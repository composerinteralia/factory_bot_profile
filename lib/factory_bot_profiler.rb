# frozen_string_literal: true

require "active_support/notifications"

require_relative "factory_bot_profiler/version"
require_relative "factory_bot_profiler/aggregate_stats"
require_relative "factory_bot_profiler/subscriber"
require_relative "factory_bot_profiler/reporters/simple_reporter"

module FactoryBotProfiler
  def self.subscribe(stats = AggregateStats.new)
    @stats = stats
    subscriber = FactoryBotProfiler::Subscriber.new(stats)
    ActiveSupport::Notifications.subscribe("factory_bot.run_factory", subscriber)
  end

  def self.report(reporter_class = Reporters::SimpleReporter)
    reporter_class.new(@stats).report if @stats
  end

  def self.merge_and_report(all_stats, reporter_class = Reporters::SimpleReporter)
    merged_stats = all_stats.reduce(AggregateStats.new, &:merge!)
    reporter_class.new(merged_stats).report
  end
end
