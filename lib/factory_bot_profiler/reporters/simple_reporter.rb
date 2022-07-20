module FactoryBotProfiler
  module Reporters
    class SimpleReporter
      N = 4

      def initialize(collector)
        @collector = collector
      end

      def report
        puts
        puts "++++++++ factory_bot stats:"
        puts
        puts "  Spent #{(@collector.total_time).round(2)} seconds in factory_bot"
        puts
        puts "  Factories taking most time overall:"
        @collector.highest_total_time(N).each do |stat|
          puts "    - :#{stat.name} factory took #{(stat.total_time).round(2)} seconds overall"
          puts "       (#{stat.total_child_time.round(2)} seconds spent in associated child factories)" unless stat.total_child_time.zero?
          puts
        end
        puts
        puts "  Slowest factories on average:"
        @collector.highest_average_time(N).each do |stat|
          puts "    - :#{stat.name} factory took #{(stat.average_time).round(2)} seconds on average"
          stat.individual_child_times.each do |factory_name, time|
            puts "      - #{time.round(2)} spent in :#{factory_name} called #{stat.individual_child_count[factory_name]}/#{stat.count} time(s)"
          end
          puts
        end
        puts
        puts "  Most used factories:"
        @collector.highest_count(N).each do |stat|
          puts "    - :#{stat.name} factory ran #{stat.count} times"
          puts
        end
      end
    end
  end
end
