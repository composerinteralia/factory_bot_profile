module FactoryBotProfiler
  module Reporters
    class SimpleReporter
      N = 4

      def initialize(collector, io)
        @collector = collector
        @io = io
      end

      def report
        @io.puts
        @io.puts "++++++++ factory_bot stats:"
        @io.puts
        @io.puts "  Spent #{(@collector.total_time).round(2)} seconds in factory_bot"
        @io.puts
        @io.puts "  Factories taking most time overall:"
        @collector.highest_total_time(N).each do |stat|
          @io.puts "    - :#{stat.name} factory took #{(stat.total_time).round(2)} seconds overall"
          @io.puts "       (#{stat.total_child_time.round(2)} seconds spent in associated child factories)" unless stat.total_child_time.zero?
        end
        @io.puts
        @io.puts "  Slowest factories on average:"
        @collector.highest_average_time(N).each do |stat|
          @io.puts "    - :#{stat.name} factory took #{(stat.average_time).round(2)} seconds on average"
        end
        @io.puts
        @io.puts "  Most used factories:"
        @collector.highest_count(N).each do |stat|
          @io.puts "    - :#{stat.name} factory ran #{stat.count} times"
        end
      end
    end
  end
end
