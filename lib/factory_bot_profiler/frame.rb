module FactoryBotProfiler
  class Frame
    attr_accessor :name, :start, :duration, :child_time, :child_count

    def initialize(name)
      @name = name
      @start = Time.now
      @child_time = Hash.new { 0 }
      @child_count = Hash.new { 0 }
    end

    def observe_child(frame)
      @child_count[frame.name] += 1

      @child_time[frame.name] += frame.self_time
      frame.child_time.each do |factory_name, time|
        @child_time[factory_name] += time
      end
    end

    def finish!
      @duration = Time.now - @start
    end

    def self_time
      raise "self time called before frame was stopped" unless @duration

      @duration - total_child_time
    end

    def total_child_time
      @child_time.reduce(0) { |sum, (k, v)| sum + v }
    end
  end
end
