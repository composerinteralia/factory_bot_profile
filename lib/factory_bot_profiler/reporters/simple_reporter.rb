module FactoryBotProfiler
  module Reporters
    class SimpleReporter
      N = 4

      def initialize(collector, output)
        @collector = collector
        @output = output
      end

      def report
        @output.puts
        @output.puts "++++++++ factory_bot stats:"
        @output.puts
        @output.puts "  Spent #{(@collector.total_time).round(2)} seconds in factory_bot"
        @output.puts
        @output.puts "  Factories taking most time overall:"
        @collector.highest_total_time(N).each do |stat|
          @output.puts "    - :#{stat.name} factory took #{(stat.total_time).round(2)} seconds overall"
          @output.puts "       (#{stat.total_child_time.round(2)} seconds spent in associated child factories)" unless stat.total_child_time.zero?
          @output.puts
        end
        @output.puts
        @output.puts "  Slowest factories on average:"
        @collector.highest_average_time(N).each do |stat|
          @output.puts "    - :#{stat.name} factory took #{(stat.average_time).round(2)} seconds on average"
          stat.individual_child_times.each do |factory_name, time|
            @output.puts "      - #{time.round(2)} spent in :#{factory_name} called #{stat.individual_child_count[factory_name]}/#{stat.count} time(s)"
          end
          @output.puts
        end
        @output.puts
        @output.puts "  Most used factories:"
        @collector.highest_count(N).each do |stat|
          @output.puts "    - :#{stat.name} factory ran #{stat.count} times"
          @output.puts
        end
      end
    end
  end
end
