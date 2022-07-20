require_relative "stack"

module FactoryBotProfiler
  class Subscriber
    def initialize(collector)
      @stack = Stack.new
      @collector = collector
    end

    def start(_, _, payload)
      @stack << payload[:name]
    end

    def finish(*)
      @collector.collect(@stack.pop)
    end
  end
end
