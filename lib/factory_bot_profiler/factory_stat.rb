module FactoryBotProfiler
  class FactoryStat
    attr_reader :name, :count, :total_time, :child_times, :child_counts

    def initialize(name)
      @name = name
      @count = 0
      @total_time = 0
      @child_times = Hash.new(0)
      @child_counts = Hash.new(0)
    end

    def increment(frame)
      @count += 1
      @total_time += frame.duration

      frame.child_time.each do |factory_name, time|
        @child_times[factory_name] += time
        @child_counts[factory_name] += 1
      end
    end

    def average_time
      total_time / count
    end

    def total_self_time
      total_time - total_child_time
    end

    def total_child_time
      child_times.values.sum
    end

    def merge!(other)
      raise "attempting to merge unrelated stats" if name != other.name

      @count += other.count
      @total_time += other.total_time
      other.child_times.each do |name, time|
        @child_times[name] += time
      end
      other.child_counts.each do |name, count|
        @child_counts[name] += count
      end
    end
  end
end
