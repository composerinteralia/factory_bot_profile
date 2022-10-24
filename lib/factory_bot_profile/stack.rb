require_relative "frame"

module FactoryBotProfile
  class Stack
    def initialize
      @stack = []
    end

    def <<(name)
      @stack << Frame.new(name)
    end

    def pop
      @stack.pop.tap do |frame|
        frame.finish!
        @stack.last.observe_child(frame) unless @stack.empty?
      end
    end
  end
end
