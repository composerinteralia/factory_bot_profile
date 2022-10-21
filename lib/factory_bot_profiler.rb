# frozen_string_literal: true

require "active_support/notifications"

require_relative "factory_bot_profiler/version"
require_relative "factory_bot_profiler/aggregate_stats"
require_relative "factory_bot_profiler/subscriber"
require_relative "factory_bot_profiler/subscription"
require_relative "factory_bot_profiler/report/simple_report"

module FactoryBotProfiler
  def self.reporting
    subscription = subscribe
    result = yield
    report(subscription.stats)
    result
  ensure
    subscription.unsubscribe
  end

  def self.subscribe(stats = AggregateStats.new)
    Subscription.new(stats).subscribe
  end

  def self.report(stats, reporter: Report::SimpleReport, io: $stdout)
    reporter.new(stats, io: io).deliver if stats
  end

  def self.merge_and_report(all_stats, reporter: Report::SimpleReport, io: $stdout)
    merged_stats = all_stats.reduce(AggregateStats.new, &:merge!)
    report(merged_stats, reporter: reporter, io: io)
  end
end
