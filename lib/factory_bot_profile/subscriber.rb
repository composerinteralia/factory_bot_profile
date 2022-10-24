require_relative "stack"

module FactoryBotProfile
  class Subscriber
    def initialize(stats)
      @stack = Stack.new
      @stats = stats
    end

    def start(_, _, payload)
      @stack << payload[:name]
    end

    def finish(*)
      @stats.collect(@stack.pop)
    end
  end
end
