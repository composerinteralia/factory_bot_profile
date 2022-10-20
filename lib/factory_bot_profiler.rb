# frozen_string_literal: true

require "active_support/notifications"

require_relative "factory_bot_profiler/version"
require_relative "factory_bot_profiler/aggregate_stats"
require_relative "factory_bot_profiler/subscriber"
require_relative "factory_bot_profiler/subscription"
require_relative "factory_bot_profiler/reporters/simple_reporter"

module FactoryBotProfiler
  def self.reporting
    stats = subscribed do
      yield
    end

    report(stats)
  end

  def self.subscribed
    subscription = subscribe
    yield
    subscription.stats
  ensure
    subscription.unsubscribe
  end

  def self.subscribe(stats = AggregateStats.new)
    Subscription.new(stats).subscribe
  end

  def self.report(stats, reporter_class = Reporters::SimpleReporter, io: $stdout)
    reporter_class.new(stats, io: io).report if stats
  end

  def self.merge_and_report(all_stats, reporter_class = Reporters::SimpleReporter, io: $stdout)
    merged_stats = all_stats.reduce(AggregateStats.new, &:merge!)
    report(merged_stats, reporter_class, io: io)
  end
end
