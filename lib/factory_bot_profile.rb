# frozen_string_literal: true

require "active_support/notifications"

require_relative "factory_bot_profile/version"
require_relative "factory_bot_profile/aggregate_stats"
require_relative "factory_bot_profile/subscriber"
require_relative "factory_bot_profile/subscription"
require_relative "factory_bot_profile/report/simple_report"

module FactoryBotProfile
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

  def self.report(stats, reporter: Report::SimpleReport, **options)
    reporter.new(stats, **options).deliver if stats
  end

  def self.merge_and_report(all_stats, reporter: Report::SimpleReport, **options)
    merged_stats = all_stats.reduce(AggregateStats.new, &:merge!)
    report(merged_stats, reporter: reporter, **options)
  end
end
