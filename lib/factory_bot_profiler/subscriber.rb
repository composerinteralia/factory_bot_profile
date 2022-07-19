module FactoryBotProfiler
  class Subscriber
    def initialize(collector)
      @collector = collector
      @stack = []
    end

    def start(_, _, payload)
      @stack << Time.now
    end

    def finish(_, _, payload)
      depth = @stack.count
      duration = Time.now - @stack.pop
      # payload[:strategy]
      @collector.collect(payload[:name], duration, depth)
    end
  end
end
