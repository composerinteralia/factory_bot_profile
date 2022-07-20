require "json"

module FactoryBotProfiler
  module Reporters
    class JsonReporter
      def initialize(collector, output)
        @collector = collector
        @output = output
      end

      def report
        report_data = {}
        @collector.each_factories do |factory|
          report_data[factory.name.to_s] = {
            count: factory.count,
            time: factory.total_time,
            self_time: factory.total_self_time,
            child_times: factory.individual_child_times,
            child_count: factory.individual_child_count
          }
        end
        @output.puts(report_data.to_json)
      end
    end
  end
end
