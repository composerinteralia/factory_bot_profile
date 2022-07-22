module FactoryBotProfiler
  class FactoryStat
    attr_reader :name, :count, :total_time, :individual_child_times, :individual_child_count

    def initialize(name)
      @name = name
      @count = 0
      @total_time = 0
      @individual_child_times = Hash.new(0)
      @individual_child_count = Hash.new(0)
    end

    def increment(frame)
      @count += 1
      @total_time += frame.duration

      frame.child_time.each do |factory_name, time|
        @individual_child_times[factory_name] += time
        @individual_child_count[factory_name] += 1
      end
    end

    def average_time
      total_time / count
    end

    def total_self_time
      total_time - total_child_time
    end

    def total_child_time
      individual_child_times.values.sum
    end

    def merge!(other)
      raise "attempting to merge unrelated stats" if name != other.name

      @count += other.count
      @total_time += other.total_time
      other.individual_child_times.each do |name, time|
        @individual_child_times[name] += time
      end
      other.individual_child_count.each do |name, count|
        @individual_child_count[name] += count
      end
    end
  end
end
