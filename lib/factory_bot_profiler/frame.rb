module FactoryBotProfiler
  class Frame
    attr_accessor :name, :start, :duration, :child_time

    def initialize(name)
      @name = name
      @start = Time.now
      @child_time = 0
    end

    def observe_child(frame)
      @child_time += frame.duration
    end

    def finish!
      @duration = Time.now - @start
    end
  end
end
