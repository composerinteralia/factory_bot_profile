require_relative "frame"

module FactoryBotProfiler
  class Subscriber
    def initialize(collector)
      @collector = collector
      @depth = 0
      @stack = []
    end

    def start(_, _, payload)
      @stack[@depth] = Frame.new(payload[:name])
      @depth += 1
    end

    def finish(*)
      @depth -= 1

      frame = @stack[@depth]
      frame.finish!

      @stack[@depth - 1].observe_child(frame) unless @depth.zero?

      @collector.collect(frame)
    end
  end
end
