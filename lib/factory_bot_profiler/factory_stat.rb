module FactoryBotProfiler
  class FactoryStat
    attr_reader :name, :count, :total_time

    def initialize(name)
      @name = name
      @count = 0
      @total_time = 0
    end

    def increment(duration)
      @count += 1
      @total_time += duration
    end

    def average_time
      total_time / count
    end
  end
end
