require_relative "factory_stat"

module FactoryBotProfiler
  class Collector
    attr_reader :total_time

    def initialize
      @total_time = 0
      @by_factory = Hash.new { |h, k| h[k] = FactoryStat.new(k) }
    end

    def collect(name, duration, depth)
      @total_time += duration if depth == 1
      @by_factory[name].increment(duration)
    end

    def highest_count(n = 1)
      take_factory_values_by(:count, n)
    end

    def highest_total_time(n = 1)
      take_factory_values_by(:total_time, n)
    end

    def highest_average_time(n = 1)
      take_factory_values_by(:average_time, n)
    end

    private

    def take_factory_values_by(stat, n)
      @by_factory.values.sort_by(&stat).last(n).reverse
    end
  end
end
