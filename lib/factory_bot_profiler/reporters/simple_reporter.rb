module FactoryBotProfiler
  module Reporters
    class SimpleReporter
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
        io.puts "  Factories taking the most time overall:"
        stats.highest_total_time(3).each do |stat|
          io.puts "    - :#{stat.name} factory took #{(stat.total_time).round(2)} seconds overall (ran #{stat.count} times)"
          stat.child_stats_by_total_time.reverse_each do |child_stat|
            io.puts "      - #{child_stat.total_time.round(2)} seconds spent in :#{child_stat.name} (ran #{child_stat.count}/#{stat.count} times)"
          end
          io.puts
        end
        io.puts
        io.puts "  Slowest factories on average:"
        stats.highest_average_time(3).each do |stat|
          io.puts "    - :#{stat.name} factory took #{(stat.average_time).round(2)} seconds on average (ran #{stat.count} times)"
          stat.child_stats_by_average_time.reverse_each do |child_stat|
            io.puts "      - #{child_stat.average_time.round(2)} seconds spent in :#{child_stat.name} on average (ran #{child_stat.count}/#{stat.count} times)"
          end
          io.puts
        end
        io.puts
        io.puts "  Most used factories:"
        stats.highest_count(5).each do |stat|
          io.puts "    - :#{stat.name} factory ran #{stat.count} times"
        end
      end

      private

      attr_reader :stats, :io
    end
  end
end
