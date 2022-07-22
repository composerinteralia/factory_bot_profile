module FactoryBotProfiler
  module Reporters
    class SimpleReporter
      N = 5

      def initialize(stats, io: $stdout)
        @stats = stats
        @io = io
      end

      def report
        io.puts
        io.puts "++++++++ factory_bot stats:"
        io.puts
        io.puts "  Spent #{(stats.total_time).round(2)} seconds in factory_bot"
        io.puts
        io.puts "  Factories taking most time overall:"
        stats.highest_total_time(N).each do |stat|
          io.puts "    - :#{stat.name} factory took #{(stat.total_time).round(2)} seconds overall"
          io.puts "       (#{stat.total_child_time.round(2)} seconds spent in associated child factories)" unless stat.total_child_time.zero?
          io.puts
        end
        io.puts
        io.puts "  Slowest factories on average:"
        stats.highest_average_time(N).each do |stat|
          io.puts "    - :#{stat.name} factory took #{(stat.average_time).round(2)} seconds on average (called #{stat.count} times)"
          stat.child_stats.each do |name, child_stat|
            io.puts "      - #{child_stat.total_time.round(2)} spent in :#{name} called #{child_stat.count}/#{stat.count} time(s)"
          end
          io.puts
        end
        io.puts
        io.puts "  Most used factories:"
        stats.highest_count(N).each do |stat|
          io.puts "    - :#{stat.name} factory ran #{stat.count} times"
          io.puts
        end
      end

      private

      attr_reader :stats, :io
    end
  end
end
