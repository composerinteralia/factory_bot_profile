require_relative "frame"

module FactoryBotProfiler
  class Subscriber
    def initialize(collector)
      @collector = collector
      @stack = []
    end

    def start(_, _, payload)
      @stack << Frame.new(payload[:name])
    end

    def finish(*)
      frame = @stack.pop
      frame.finish!

      @stack[-1].observe_child(frame) unless @stack.empty?

      @collector.collect(frame)
    end
  end
end
