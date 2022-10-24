module FactoryBotProfile
  class Frame
    attr_accessor :name, :start, :child_time

    def initialize(name)
      @name = name
      @start = Time.now
      @child_time = Hash.new { 0 }
    end

    def observe_child(frame)
      @child_time[frame.name] += frame.self_time
      frame.child_time.each do |factory_name, time|
        @child_time[factory_name] += time
      end
    end

    def duration
      raise "self time called before frame was stopped" unless @duration
      @duration
    end

    def finish!
      @duration = Time.now - @start
    end

    def self_time
      duration - total_child_time
    end

    def total_child_time
      @child_time.values.sum
    end
  end
end
