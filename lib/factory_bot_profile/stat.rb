module FactoryBotProfile
  class Stat
    attr_reader :name, :count, :total_time

    def initialize(name)
      @name = name
      @count = 0
      @total_time = 0
    end

    def average_time
      total_time / count
    end

    def merge!(other)
      raise "attempting to merge unrelated stats" if name != other.name

      @count += other.count
      @total_time += other.total_time
    end
  end

  class ChildStat < Stat
    def increment(time)
      @count += 1
      @total_time += time
    end
  end

  class FactoryStat < Stat
    attr_reader :child_stats

    def initialize(name)
      super
      @child_stats = child_stats_hash
    end

    def increment(frame)
      @count += 1
      @total_time += frame.duration

      frame.child_time.each do |name, time|
        @child_stats[name].increment(time)
      end
    end

    def total_self_time
      total_time - total_child_time
    end

    def total_child_time
      child_stats.values.map(&:total_time).sum
    end

    def child_stats_by_total_time
      child_stats.values.sort_by(&:total_time)
    end

    def child_stats_by_average_time
      child_stats.values.sort_by(&:average_time)
    end

    def merge!(other)
      super

      other.child_stats.each do |name, stat|
        @child_stats[name].merge!(stat)
      end
    end

    def marshal_dump
      [@name, @count, @total_time, Hash[@child_stats]] # rubocop:disable Style/HashConversion
    end

    def marshal_load(data)
      @name, @count, @total_time, child_stats = data
      @child_stats = child_stats_hash.merge!(child_stats)
    end

    private

    def child_stats_hash
      Hash.new { |h, k| h[k] = ChildStat.new(k) }
    end
  end
end
