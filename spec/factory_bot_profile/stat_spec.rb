# frozen_string_literal: true

RSpec.describe FactoryBotProfile::FactoryStat do
  it "serializes via Marshal" do
    stat = FactoryBotProfile::FactoryStat.new(:test)

    marshal_stat = Marshal.load(Marshal.dump(stat))

    expect(marshal_stat.name).to eq(stat.name)
  end

  describe "#merge!" do
    it "merges the values from another factory_stat" do
      stat = FactoryBotProfile::FactoryStat.new(:stat)
      frame = build_frame(duration: 2, child_time: {a: 1, b: 2})
      stat.increment(frame)

      other_stat = FactoryBotProfile::FactoryStat.new(:stat)
      other_frame = build_frame(duration: 5, child_time: {a: 2, c: 1})
      other_stat.increment(other_frame)

      stat.merge!(other_stat)

      expect(stat.total_time).to eq(7)

      child_times = stat.child_stats.transform_values(&:total_time)
      expect(child_times).to eq(a: 3, b: 2, c: 1)

      child_counts = stat.child_stats.transform_values(&:count)
      expect(child_counts).to eq(a: 2, b: 1, c: 1)
    end
  end

  def build_frame(duration:, child_time:)
    double(FactoryBotProfile::Frame, duration: duration, child_time: child_time)
  end
end
