module FactoryBotProfiler
  module Reporters
    class SimpleReporter
      N = 4

      def initialize(stats)
        @stats = stats
      end

      def report
        puts
        puts "++++++++ factory_bot stats:"
        puts
        puts "  Spent #{(@stats.total_time).round(2)} seconds in factory_bot"
        puts
        puts "  Factories taking most time overall:"
        @stats.highest_total_time(N).each do |stat|
          puts "    - :#{stat.name} factory took #{(stat.total_time).round(2)} seconds overall"
          puts "       (#{stat.total_child_time.round(2)} seconds spent in associated child factories)" unless stat.total_child_time.zero?
          puts
        end
        puts
        puts "  Slowest factories on average:"
        @stats.highest_average_time(N).each do |stat|
          puts "    - :#{stat.name} factory took #{(stat.average_time).round(2)} seconds on average (called #{stat.count} times)"
          stat.child_times.each do |factory_name, time|
            puts "      - #{time.round(2)} spent in :#{factory_name} called #{stat.child_counts[factory_name]}/#{stat.count} time(s)"
          end
          puts
        end
        puts
        puts "  Most used factories:"
        @stats.highest_count(N).each do |stat|
          puts "    - :#{stat.name} factory ran #{stat.count} times"
          puts
        end
      end
    end
  end
end
