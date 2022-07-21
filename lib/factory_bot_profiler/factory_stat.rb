module FactoryBotProfiler
  class FactoryStat
    attr_reader :name, :count, :total_time, :total_child_time

    def initialize(name)
      @name = name
      @count = 0
      @total_time = 0
      @total_child_time = 0
    end

    def increment(frame)
      @count += 1
      @total_time += frame.duration
      @total_child_time += frame.child_time
    end

    def average_time
      total_time / count
    end

    def total_self_time
      total_time - total_child_time
    end

    def merge!(other)
      raise "attempting to merge unrelated stats" if name != other.name

      @count += other.count
      @total_time += other.total_time
      @total_child_time += other.total_child_time
    end
  end
end
