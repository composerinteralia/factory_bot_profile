require_relative "factory_stat"

module FactoryBotProfiler
  class Collector
    def initialize
      @by_factory = Hash.new { |h, k| h[k] = FactoryStat.new(k) }
    end

    def collect(frame)
      @by_factory[frame.name].increment(frame)
    end

    def total_time
      @by_factory.values.map(&:total_self_time).sum
    end

    def highest_count(n = 1)
      take_factory_values_by(:count, n)
    end

    def highest_total_time(n = 1)
      take_factory_values_by(:total_time, n)
    end

    def highest_self_time(n = 1)
      take_factory_values_by(:total_self_time, n)
    end

    def highest_average_time(n = 1)
      take_factory_values_by(:average_time, n)
    end

    def merge!(other)
      other.each_factory do |name, stat|
        @by_factory[name].merge!(stat)
      end

      self
    end

    def each_factory(...)
      @by_factory.each(...)
    end

    private

    def take_factory_values_by(stat, n)
      @by_factory.values.sort_by(&stat).last(n).reverse
    end
  end
end
