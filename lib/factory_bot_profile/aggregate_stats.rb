require_relative "stat"

module FactoryBotProfile
  class AggregateStats
    def initialize
      @by_factory = stats_hash
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

    def marshal_dump
      # Cannot dump hash with a default proc, so make a copy with no default
      # Need to disable standard because to_h is not the same thing in this case
      Hash[@by_factory] # rubocop:disable Style/HashConversion
    end

    def marshal_load(by_factory)
      @by_factory = stats_hash.merge!(by_factory)
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

    def stats_hash
      Hash.new { |h, k| h[k] = FactoryStat.new(k) }
    end

    def take_factory_values_by(stat, n)
      @by_factory.values.sort_by(&stat).last(n).reverse
    end
  end
end
